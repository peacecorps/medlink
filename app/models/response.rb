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
    ResponseSMSJob.enqueue id
    MailerJob.enqueue :fulfillment, id
  end

  def mark_updated_orders!
    supply_ids = supplies.pluck :id
    user.orders.where(supply_id: supply_ids, delivery_method: nil).each do |o|
      o.update_attributes response_id: id
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
