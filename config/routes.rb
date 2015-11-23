require 'sidekiq/web'
Medlink::Application.routes.draw do
  devise_for :users, controllers: { confirmations: "confirmations" }, skip: [:registrations]
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
    member do
      get :timeline
    end

    resources :responses, only: [:new, :create, :show] do
      post :archive
      post :unarchive
    end
  end

  resources :messages, only: [:index]
  resources :announcements do
    member do
      post :deliver
    end
  end

  resources :requests, only: [:new, :create]

  resources :supplies, only: [:index, :new, :create] do
    member do
      patch :toggle_orderable
    end
  end

  resources :orders, only: [:index] do
    collection do
      get :manage
    end
  end

  resources :responses, only: [:index] do
    member do
      post :mark_received
      post :flag
      post :cancel
      post :reorder
    end
  end

  resources :reports, only: [:index] do
    collection do
      get :order_history
      get :users
      get :pcmo_response_times
    end
  end

  namespace :admin do
    resources :users, only: [:new, :create, :edit, :update] do
      member do
        patch :inactivate
      end

      collection do
        get  :select
        post :upload_csv
        post :set_country
      end
    end
  end

  get '/help' => 'pages#help'
  root to: 'pages#root'

  post '/medrequest' => 'twilio#receive'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq', as: 'sidekiq'
  end

  namespace :api do
    namespace :v1 do
      post '/login' => 'auth#login'
      resources :supplies, only: [:index]
    end
  end
end
