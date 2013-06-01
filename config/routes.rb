require 'resque/server'

Rhok::Application.routes.draw do
  devise_for :users

  resources :requests
  resources :users
  resources :med_requests

  root to: 'application#root'
  
  match '/medrequest', to: 'twilio#create'
end
