Shoppe::Engine.routes.draw do
  
  get 'attachment/:id/:filename.:extension' => 'attachments#show'
  resources :product_categories
  resources :products do
    match :stock_levels, :on => :member, :via => [:get, :post]
  end
  resources :orders do
    post :search, :on => :collection
    post :accept, :on => :member
    post :reject, :on => :member
    post :ship, :on => :member
    post :pay, :on => :member
  end
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :users
  resources :attachments, :only => :destroy
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  match 'login/reset' => 'sessions#reset', :via => [:get, :post]
  
  delete 'logout' => 'sessions#destroy'
  root :to => 'dashboard#home'
end
