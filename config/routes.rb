Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'profiles#show'
  resource :profile, only: [:show, :edit, :update]

  namespace :admin do
    resources :users do
      collection do
        get 'export'
      end
      member do
        get 'send_email'
      end
    end
  end
end
