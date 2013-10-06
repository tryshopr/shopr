Shoppe::Engine.routes.draw do

  resources :product_categories
  resources :products
  resources :orders do
    post :search, :on => :collection
    post :accept, :on => :member
    post :reject, :on => :member
    post :ship, :on => :member
  end
  resources :delivery_services do
    resources :delivery_service_prices
  end
  resources :users
  resources :attachments, :only => :destroy
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  root :to => redirect('products')
end
