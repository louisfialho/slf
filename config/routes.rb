Rails.application.routes.draw do
  devise_for :users
  root to: 'shelves#shelf'
  resources :shelves, only: [:new, :create, :show]
  resources :spaces do
    collection do
      get :move_space_to_space
      get :move_space_to_shelf
    end
    member do
      patch :move
    end
  end
  resources :items do
    collection do
      get :move_to_space
      get :move_to_shelf
    end
    member do
      patch :move
    end
  end
end
