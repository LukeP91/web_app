require "sidekiq/web"
Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'profiles#show'
  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    resources :users do
      collection do
        get 'export'
        get 'welcome_email'
      end
      member do
        get 'send_email'
      end
    end

    resources :categories
    resources :interests
  end

  namespace :api do
    resources :users
  end
end
