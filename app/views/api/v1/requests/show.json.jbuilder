json.request do
  json.partial! "show", locals: { request: @request }
end
