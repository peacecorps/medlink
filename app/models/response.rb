class Response < ActiveRecord::Base
  include Concerns::UserScope

  belongs_to :message

  has_many :orders
  has_many :supplies, through: :orders

  default_scope { where(archived_at: nil) }

  def archive!
    update_attributes archived_at: Time.now
  end

  def sms_instructions
    SMS::Condenser.new("sms.response.#{type}", :supply,
      supplies: supply_names
    ).message
  end

  def send!
    ResponseSMSJob.enqueue id
    MailerJob.enqueue :fulfillment, id
  end

  private

  def supply_names
    supplies.map { |s| "#{s.name} (#{s.shortcode})" }
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
