Rhok::Application.routes.draw do
  root to: 'application#root'
  
  match '/medrequest', to: 'med_requests#create'
end
