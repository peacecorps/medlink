json.orders @orders do |o|
  json.request_id o.request_id

  json.supply do
    json.(o.supply, :id, :name, :shortcode)
  end

  json.placed_at o.created_at
end
