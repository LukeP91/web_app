Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'dashboard#index'
  resource :profile, only: [:show]
end
