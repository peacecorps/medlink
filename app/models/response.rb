class Response < ActiveRecord::Base
  MAX_LENGTH = 160

  include Concerns::UserScope

  belongs_to :message
  belongs_to :replacement, class_name: "Request"

  has_many :orders
  has_many :supplies, through: :orders

  has_many :receipt_reminders

  validates :extra_text, length: { maximum: MAX_LENGTH }

  def set_text text
    self.extra_text = text.slice(0, MAX_LENGTH)
  end

  def sms_instructions
    SMS::Condenser.new("sms.response.#{type}", :supply,
      supplies: supply_names
    ).message
  end

  def send!
    ResponseSMSJob.perform_later self
    UserMailer.fulfillment(self).deliver_later
  end

  def mark_updated_orders!
    supply_ids = supplies.pluck :id
    user.orders.where(supply_id: supply_ids, delivery_method: nil).each do |o|
      o.update_attributes response_id: id
    end
  end

  def auto_archivable?
    orders.all? { |o| o.delivery_method && o.delivery_method.auto_archive? }
  end

  def flag!
    update! flagged: true
  end

  def mark_received! by: nil
    by_id = by ? by.id : user_id
    update! received_at: Time.now, received_by: by_id, flagged: false
  end

  def cancel!
    update! cancelled_at: Time.now
  end

  def reorder! by:
    rc = RequestCreator.new by, supplies: supplies, \
      request: { user_id: user.id, reorder_of_id: id}
    rc.save
    update! replacement: rc.request, cancelled_at: rc.request.created_at
  end

  def received?
    received_at.present?
  end

  def cancelled?
    cancelled_at.present?
  end

  def archived?
    received? || cancelled?
  end

  def reordered?
    replacement_id.present?
  end

  def reordered_at
    replacement.try :created_at
  end

  def outstanding?
    !(flagged? || archived?)
  end

  def needs_receipt_reminder?
    return false unless outstanding?
    return false if created_at >= 7.days.ago # Allow some time for items to arrive.
    return false if created_at < 30.days.ago # _Many_ old orders won't have responses. Don't want to spam folks.

    # No more than once a day
    last_reminded_at = receipt_reminders.maximum :created_at
    last_reminded_at.nil? || last_reminded_at < 1.day.ago
  end

  def send_receipt_reminder!
    return false unless needs_receipt_reminder?

    slack = Slackbot.new
    if receipt_reminders.count >= 3
      flag!
      slack.message "Flagged response #{id} for manual follow-up after #{receipt_reminders.count} reminders"
      return
    end

    text = SMS::Condenser.new("sms.response.receipt_reminder", :supply,
      supplies: supply_names, response_date: created_at.strftime("%B %d")).message

    Rails.logger.info "Pinging #{user.email} to acknowledge receipt of response #{id}"
    if sms = user.send_text(text)
      receipt_reminders.create!(user: user, message: sms)
    end
  end

private

  def supply_names
    supplies.uniq.map { |s| "#{s.name} (#{s.shortcode})" }
  end

  def type
    methods = orders.map(&:delivery_method).uniq
    if methods.length == 1
      methods.first.name
    elsif methods.include? DeliveryMethod::Denial
      :partial_denial
    else
      :mixed_approval
    end
  end
end
