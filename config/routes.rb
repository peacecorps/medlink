require 'resque/server'

Rhok::Application.routes.draw do
  devise_for :users, :controllers => { registrations: 'registrations' }

  resources :orders

  resources :users, only: [:create, :destroy, :update, :index] do
    collection { get :current }
  end

  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]

  root to: 'application#root'

  match '/medrequest', to: 'twilio#receive'
  match '/supply_list' => 'application#root'

  mount Resque::Server, at: '/resque', as: 'resque'
end
