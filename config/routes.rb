Medlink::Application.routes.draw do
  devise_for :users, :defaults => { :format => 'json' },
    :controllers => { registrations: 'registrations', sessions: 'sessions' }

  resources :orders

  resources :users, only: [:create, :destroy, :update, :index] do
    collection { get :current }
  end

  resources :supplies, only: [:index]
  resources :requests, only: [:create, :destroy, :update]
  
  get '/about' => 'application#about'
  get '/help'  => 'application#help'
  root to: 'application#root'

  match '/medrequest'  => 'twilio#receive'
end
