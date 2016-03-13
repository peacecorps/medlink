json.text request.text
json.created_at request.created_at
json.supplies request.orders.includes(:response) do |order|
  response = order.response

  json.id order.supply_id

  if order.response_id
    json.response do
      json.(order.response, :id, :created_at)
      if order.duplicated_at
        json.type "duplicate"
      else
        json.type order.delivery_method.title
      end
    end

    if response.received?
      json.status "received"
      json.received_at response.received_at
    elsif response.flagged?
      json.status "flagged"
    else
      json.status "responded"
      json.responded_at response.created_at
    end
  else
    json.response nil
    json.status "pending"
  end
end
