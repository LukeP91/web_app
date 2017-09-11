require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'profiles#show'
  resource :profile, only: %i[show edit update]

  namespace :admin do
    resources :users do
      collection do
        get 'export'
        get 'welcome_email'
      end
      member do
        get 'send_email'
        post 'send_welcome_sms'
      end
    end

    resource :statistics, only: :show
    resources :hash_tags, only: %i[index show]
    resources :categories
    resources :interests
    resources :sources, only: %i[index new create destroy]

  end

  get '/auth/facebook'
  get '/auth/facebook/callback', to: 'authorize_facebook#create'

  namespace :api do
    resources :users, only: %i[show index create update destroy] do
      resources :interests, only: [:index]
    end
  end
end
