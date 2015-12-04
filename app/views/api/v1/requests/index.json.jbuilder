json.requests @requests.includes orders: :response do |request|
  json.created_at request.created_at
  json.supplies request.orders do |order|
    # TODO: just render the show template
    json.id order.supply_id
    if order.response_id
      json.response do
        json.(order.response, :id, :created_at)
        json.type order.delivery_method.title
      end
    else
      json.response nil
    end
  end
end
