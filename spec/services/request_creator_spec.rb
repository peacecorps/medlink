require "spec_helper"

describe RequestCreator do
  it 'can mark duplicate orders for the same supply' do
    pcv    = create :pcv
    supply = create :supply

    orders = 2.times.map { create :order, user: pcv, supply: supply }
    expect( orders.none? &:duplicated? ).to eq true

    rc = RequestCreator.new(pcv, request: {
      text:              "Updating old request",
      user_id:           pcv.id,
      orders_attributes: { "1" => { supply_id: supply.id } }
    })

    expect( rc.save ).to eq true

    orders.map &:reload
    expect( orders.all? &:duplicated? ).to eq true
    expect( supply.orders.order(created_at: :desc).first.duplicated? ).to be false
  end
end
