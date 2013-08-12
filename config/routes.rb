Medlink::Application.routes.draw do
  devise_for :users, :controllers => { :passwords => "passwords" }

  resources :orders do
    get :report, on: :collection
  end

  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update]
  end

  get '/help' => 'application#help'
  root to: 'application#root'

  post '/medrequest' => 'twilio#receive'
end
