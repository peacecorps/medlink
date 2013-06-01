Rhok::Application.routes.draw do
  devise_for :users

  root to: 'application#root'
  
  match '/medrequest', to: 'med_requests#create'
end
