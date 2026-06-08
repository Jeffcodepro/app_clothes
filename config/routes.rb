Rails.application.routes.draw do
  devise_for :users

  root to: "pages#home"

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
