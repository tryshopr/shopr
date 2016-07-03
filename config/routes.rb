Shopr::Engine.routes.draw do

  devise_for :users, class_name: "Shopr::User", module: :devise

  get 'attachment/:id/:filename.:extension' => 'attachments#show'

  resources :customers do
    post :search, on: :collection
    resources :addresses
  end

  resources :product_categories
  resources :products do
    resources :variants
    collection do
      get :import
      post :import
    end
  end
  resources :orders do
    collection do
      post :search
    end
    member do
      post :accept
      post :reject
      post :ship
      get :despatch_note
    end
    resources :payments, only: [:create, :destroy] do
      match :refund, on: :member, via: [:get, :post]
    end
  end
  resources :stock_level_adjustments, only: [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :users
  resources :countries
  resources :attachments, only: :destroy

  get 'settings' => 'settings#edit'
  post 'settings' => 'settings#update'

  root to: 'dashboard#home'
end
