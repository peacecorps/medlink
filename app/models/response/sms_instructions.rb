class Response::SmsInstructions
  def initialize orders
    @orders = orders.includes :supply
  end

  def to_s
    SMS::Condenser.new("sms.response.#{type}", :supply,
      supplies: supply_names
    ).message
  end

  private

  attr_reader :orders

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

  def supply_names
     orders.map { |o| o.supply.select_display }.uniq
  end
end
