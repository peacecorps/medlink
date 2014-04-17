require 'spec_helper'

describe Response do
  before :each do
    @user = create :user
    @response = create :response, user: @user
    3.times do
      create :order,
        user:            @user,
        response:        @response,
        delivery_method: DeliveryMethod::Pickup
    end
  end

  pending "SMS response text"
  pending "Email response contents"

  it "can de-serialize responded orders" do
    expect( Order.last.delivery_method ).to respond_to :name
  end

  it "stores simple strings in the database" do
    raw = Order.connection.execute %{
      SELECT delivery_method
      FROM orders
      ORDER BY id DESC
      LIMIT 1
    }.squish
    expect( raw.first["delivery_method"] ).to eq "pickup"
  end
end
