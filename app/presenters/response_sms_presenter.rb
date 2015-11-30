class ResponseSMSPresenter < ApplicationPresenter
  delegate_all

  def instructions
    SMS::Condenser.new("sms.response.#{type}", :supply,
      supplies: supply_names
    ).message
  end

  private

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
    orders.includes(:supply).map { |o| o.supply.select_display }.uniq
  end
end
