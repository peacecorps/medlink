require 'sidekiq/web'

Medlink::Application.routes.draw do
  devise_for :users, controllers: { confirmations: "confirmations" }, skip: [:registrations]
  as :user do
    get   'users/edit' => 'devise/registrations#edit',   as: 'edit_user_registration'
    patch 'users/:id'  => 'devise/registrations#update', as: 'user_registration'
    patch 'confirm'    => 'confirmations#confirm'
    post  'users/sign_in/help' => 'users#send_login_help', as: 'send_login_help'
  end

  resource :welcome, only: [:show, :update]

  resources :users, only: [] do
    resource  :timeline, only: [:show]
    resources :responses, only: [:new, :create]
  end
  patch "/user/country"  => "users#set_country", as: :set_country

  resource :timeline, only: [:show]

  resources :messages, only: [:index]
  resources :announcements, except: [:show] do
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

  resources :orders, only: [] do
    collection do
      get :manage
    end
  end

  resources :responses, only: [:index, :show] do
    member do
      post :mark_received
      post :flag
      post :cancel
      post :reorder
    end
  end

  resources :reports, only: [:index], param: :name do
    get :download
  end

  resource :country, only: [:update] do
    resources :supplies, only: [:index], controller: "country_supplies" do
      member do
        patch :toggle
      end
    end

    resource :roster, only: [:show, :edit, :update] do
      collection do
        post :upload
        get  :poll
      end
    end
  end

  namespace :admin do
    root  "pages#dashboard"

    resources :users, only: [:new, :create, :edit, :update] do
      member do
        post   :activate
        delete :inactivate
      end

      collection do
        get :select
      end
    end
  end

  get '/help' => 'pages#help'
  get '/.well-known/acme-challenge/:id' => 'pages#letsencrypt'
  root to: 'pages#root'

  post '/medrequest' => 'twilio#receive'
  post '/slack'      => 'slack#command'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq', as: 'sidekiq'
  end

  namespace :api do
    namespace :v1 do
      post '/auth'       => 'auth#login'
      post '/auth/phone' => 'auth#phone_login'
      get  '/auth'       => 'auth#test'

      resources :countries, only: [] do
        resources :users, only: [:index]
      end

      resources :supplies, only: [:index] do
        collection do
          get '/all' => 'supplies#master_list'
        end
      end

      resources :orders, only: [:index]

      resources :requests, only: [:create, :index]

      resources :users, only: [:index, :update]

      resources :responses, only: [] do
        member do
          post :mark_received
          post :flag
        end
      end
    end
  end
end
