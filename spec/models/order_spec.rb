require "rails_helper"

RSpec.describe Order do
  context "serializing delivery methods" do
    Given(:order) { FactoryGirl.create :order, delivery_method: nil }
    When(:result) { order.update! delivery_method: :pickup }

    Then { result == true                                                 }
    And  { order.delivery_method                == DeliveryMethod::Pickup }
    And  { Order.find(order.id).delivery_method == DeliveryMethod::Pickup }
  end
end
