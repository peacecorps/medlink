require 'resque/server'

Rhok::Application.routes.draw do
  devise_for :users

  resources :orders
  resources :users
  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]

  root to: 'application#root'
  
  match '/medrequest', to: 'twilio#create'
end
