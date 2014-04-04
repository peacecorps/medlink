Medlink::Application.routes.draw do
  devise_for :users, :controllers => { :passwords => "passwords" }, :skip => [:registrations]
  as :user do
    get 'users/edit' => 'devise/registrations#edit', :as => 'edit_user_registration'
    patch 'users/:id' => 'devise/registrations#update', :as => 'user_registration'
  end

  resources :reports, only: [:index] do
    [:order_history, :users, :pcmo_response_times].each do |r|
      get r, on: :collection
    end
  end

  resources :orders, only: [:index, :new, :create] do
    get :manage, on: :collection
  end

  resources :supplies, only: [:index]

  resources :users, only: [] do
    resources :responses, only: [:new, :create, :show]
  end

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update]
    post 'users/uploadCSV' => 'users#uploadCSV'
  end

  get '/help' => 'application#help'
  root to: 'application#root'

  post '/medrequest' => 'twilio#receive'
end
