Shoppe::Engine.routes.draw do
  
  get 'attachment/:id/:filename.:extension' => 'attachments#show'
  resources :product_categories
  resources :products
  resources :orders do
    post :search, :on => :collection
    post :accept, :on => :member
    post :reject, :on => :member
    post :ship, :on => :member
    post :pay, :on => :member
  end
  resources :stock_level_adjustments, :only => [:index, :create]
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :tax_rates
  resources :users
  resources :attachments, :only => :destroy
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'login/reset' => 'sessions#reset', :via => [:get, :post]
  
  delete 'logout' => 'sessions#destroy'
  root :to => 'dashboard#home'
end
