Rails.application.routes.draw do
  devise_for :users
  root to: 'shelves#shelf'
  resources :shelves, only: [:new, :create, :show]
  resources :spaces
  resources :items
end
