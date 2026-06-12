Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root to: "pages#home"

  get "mais-vendidos-da-semana", to: "best_sellers#index", as: :weekly_best_sellers

  resource :liked_products, only: [:show]

  resources :products, only: [:index, :show] do
    resource :like, only: [:create, :destroy]
    resource :favorite, only: [:create, :destroy]
  end

  resources :categories, only: [:show]
  resources :sections, only: [:show]

  resource :cart, only: [:show]
  resources :cart_items, only: [:create, :update, :destroy]

  resources :orders, only: [:index, :show, :new, :create]

  namespace :admin do
    root to: "dashboard#index"

    resources :products
    resources :categories
    resources :sections
    resources :orders, only: [:index, :show, :update]
    resources :analytics, only: [:index]
  end
end
