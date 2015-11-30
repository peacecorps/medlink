json.request do
  json.created_at @request.model.created_at
  json.supplies @request.model.orders.includes(:response) do |order|
    json.id            order.supply_id
    # TODO: this should probably be a nested response
    json.response_id   order.response_id
    json.response_type order.delivery_method.try(:title)
    json.responded_at  order.response.try(:created_at)
  end
end
