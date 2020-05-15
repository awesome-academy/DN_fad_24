Rails.application.routes.draw do
  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"

    get "/home", to: "static_pages#home"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    devise_for :users
    resources :users do
      member do
        get :confirm_email
      end
    end
    namespace :admin do
      resources :categories
      resources :products
      resources :users
      resources :orders
      resources :contacts
      resources :export_users, only: :index
      resources :imports
    end
    resources :products
    resources :carts
    resources :orders
    resources :products_detail, only: :show
    resources :users
    resources :orders_histories, only: [:index, :show]
    resources :contacts, only: [:new, :create]
    resources :account_activations, only: :edit
  end
end
