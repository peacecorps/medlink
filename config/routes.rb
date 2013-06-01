Rhok::Application.routes.draw do
  root to: 'application#root'
  
  match '/medrequest', to: 'twilio#create'
end
