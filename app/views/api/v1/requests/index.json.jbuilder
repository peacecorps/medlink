json.requests @requests.includes orders: :response do |request|
  json.partial! "show", locals: { request: request }
end
