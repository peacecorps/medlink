require 'resque/server'

Rhok::Application.routes.draw do
  devise_for :users

  root to: 'application#root'
  
  match '/medrequest', to: 'med_requests#create'

  devise_for :users

  # TODO: lock this down to admins
  mount Resque::Server, at: '/resque', as: 'resque'
end
