Medlink::Application.routes.draw do
  get "report/request_history"
  get "report/fulfillment_history"
  get "report/recent_adds"
  get "report/recent_edits"
  get "report/pcmo_response_times"
  get "report/supply_history"
  devise_for :users, :controllers => { :passwords => "passwords" }

  resources :orders do
    get :report, on: :collection
  end

  resources :supplies, only: [:index]
  #resources :requests, only: [:create, :destroy, :update]

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update]
  end

  get '/help' => 'application#help'
  root to: 'application#root'

  post '/medrequest' => 'twilio#receive'
end
