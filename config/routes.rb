Rails.application.routes.draw do
  namespace :item do
    get 'steps/show'
    get 'steps/update'
  end
  devise_for :users
  root to: 'shelves#shelf'
  resources :shelves, only: [:new, :create, :show]
  resources :spaces
  resources :items do
    resources :steps, only: [:show, :update], controller: 'item/steps' #/items/1/steps/identity
    collection do
      get :move_to_space
      get :move_to_shelf
    end
  end
end
