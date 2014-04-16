require 'spec_helper'

describe Response do
  before :each do
    @user = create :user
    @response = create :response, user: @user
    3.times { create :order, user: @user, response: @response, delivery_method: DeliveryMethod.to_a.sample }
  end

  pending "SMS response text"
  pending "Email response contents"

  it "can de-serialize responded orders" do
    # TODO - want these stored as strings, not YAML
    expect( Order.last.delivery_method ).to respond_to :name
  end
end
