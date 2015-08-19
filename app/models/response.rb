class Response < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message

  has_many :orders
  has_many :supplies, through: :orders

  def archived?  ; !!archived_at ; end
  def archive!   ; update_attributes archived_at: Time.now ; end
  def unarchive! ; update_attributes archived_at: nil      ; end

  def sms_instructions
    SMS::Condenser.new("sms.response.#{type}", :supply,
      supplies: supply_names
    ).message
  end

  def send!
    ResponseSMSJob.perform_later id
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

  def received?
    received_at.present?
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
