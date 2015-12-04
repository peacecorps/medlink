json.request do
  json.created_at @request.model.created_at
  json.supplies @request.model.orders.includes(:response) do |order|
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
