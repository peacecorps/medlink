require 'resque/server'

Rhok::Application.routes.draw do
  get "requests/new"

  get "requests/create"

  get "requests/delete"

  get "requests/destroy"

  get "requests/edit"

  get "requests/update"

  devise_for :users

  resources :users
  resources :med_requests

  root to: 'application#root'
  
  match '/medrequest', to: 'twilio#create'
end
