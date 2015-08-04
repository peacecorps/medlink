require 'spec_helper'

describe "Duplicate orders" do
  it "can pass through the system", :worker do
    user = create :user
    create :phone, user: user
    %w( A B C ).each do |name|
      @supply = create :supply, name: name, shortcode: name
      user.country.supplies << @supply
    end

    SMS.receive user.primary_phone.number, "A B - first instructions"
    SMS.receive user.primary_phone.number, "A C - second instructions"

    pcmo = create :pcmo, country: user.country
    login pcmo
    visit new_user_response_path(user)

    dup = Order.all.find &:duplicated_at
    expect( dup ).to be_present
    expect( page.find "#new_response" ).to have_content "Updated"

    Order.all.reject(&:duplicated_at).each do |o|
      choose :"orders_#{o.id}_delivery_method_delivery"
    end
    click_on "Send Response"

    updup = Order.find dup.id
    expect( dup.request_id ).to be_present
    expect( user.orders.without_responses ).to be_empty
  end
end
