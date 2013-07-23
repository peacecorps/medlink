Medlink::Application.routes.draw do
  devise_for :users

  resources :orders

  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]
  
  get '/help' => 'application#help'
  root to: 'application#root'

  get '/medrequest' => 'twilio#receive'
end
