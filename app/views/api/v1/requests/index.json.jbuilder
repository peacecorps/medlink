json.requests @requests.includes orders: :response do |request|
  json.created_at request.created_at
  json.supplies request.orders do |order|
    json.id            order.supply_id
    # TODO: this should probably be a nested response. Render :show?
    json.response_id   order.response_id
    json.response_type order.delivery_method.try(:title)
    json.responded_at  order.response.try(:created_at)
  end
end
