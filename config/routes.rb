Medlink::Application.routes.draw do
  devise_for :users

  resources :orders do
    get :report, on: :collection
  end

  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]

  resource :admin
  
  get '/help' => 'application#help'
  root to: 'application#root'

  get '/medrequest' => 'twilio#receive'
end
