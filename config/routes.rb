Medlink::Application.routes.draw do
  devise_for :users, :controllers => { :passwords => "passwords" }

  resources :reports, only: [:index] do
    [:request_history, :fulfillment_history, :supply_history,
     :recent_adds, :recent_edits, :pcmo_response_times].each do |r|
      get r, on: :collection
    end
  end
  
  resources :orders do
    get :manage, on: :collection
  end

  resources :supplies, only: [:index]

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update]
  end

  get '/help' => 'application#help'
  root to: 'application#root'

  post '/medrequest' => 'twilio#receive'
end
