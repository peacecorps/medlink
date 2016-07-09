require "rails_helper"

RSpec.describe Api::V1::OrdersController do
  context "as a volunteer" do
    context "with no orders" do
      As   { pcv }
      When { get :index }

      Then { json["orders"] == [] }
    end

    context "with an order" do
      Given(:order) { create :order }

      As   { order.user }
      When { get :index }

      Then { json["orders"].first["supply"]["name"] == order.supply.name }
    end
  end

  context "unauthenticated" do
    When { get :index }

    Then { status == 401 }
  end
end
