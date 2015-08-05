describe RequestCreator do
  it 'can mark duplicate orders for the same supply'
  # FIXME: this was the old user-object based test
    #pcv    = create :pcv
    #supply = create :supply

    #orders = 3.times.map { create :order, user: pcv, supply: supply }
    #expect( orders.none? &:duplicated? ).to eq true

    #pcv.mark_updated_orders
    #orders.map &:reload
    #expect( orders.first(2).all? &:duplicated? ).to eq true
    #expect( orders.last.duplicated? ).to be false
end
