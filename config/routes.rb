require 'sidekiq/web'
Medlink::Application.routes.draw do
  devise_for :users, controllers: { passwords: "passwords", confirmations: "confirmations" }, skip: [:registrations]
  as :user do
    get   'users/edit' => 'devise/registrations#edit',   as: 'edit_user_registration'
    patch 'users/:id'  => 'devise/registrations#update', as: 'user_registration'
    patch 'confirm'    => 'confirmations#confirm'
    post  'users/sign_in/help' => 'users#send_login_help', as: 'send_login_help'
  end

  resources :country_supplies, only: [:index, :create]

  resource :user, only: [:edit, :update] do
    get   '/welcome/video' => 'users#welcome_video', as: 'welcome_video'
    post  '/welcome' => 'users#confirm_welcome', as: 'welcome_shown'
  end

  resources :users, only: [] do
    resources :responses, only: [:new, :create, :show] do
      post :archive
      post :unarchive
    end
  end

  resources :requests, only: [:new, :create]

  resources :orders, only: [:index] do
    get :manage, on: :collection
  end

  resources :responses, only: [:index]

  resources :reports, only: [:index] do
    [:order_history, :users, :pcmo_response_times].each do |r|
      get r, on: :collection
    end
  end

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update] do
      collection do
        post :upload_csv
        post :set_country
      end
    end

    resources :messages, only: [:index, :create]
  end

  get '/help' => 'pages#help'
  root to: 'pages#root'

  post '/medrequest' => 'twilio#receive'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq', as: 'sidekiq'
  end
end
