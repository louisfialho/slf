Rails.application.routes.draw do
  devise_for :users
  root to: "shelves#index"
  resources :shelves
  get 'spaces/new', to: 'spaces#new'
  post 'spaces', to: 'spaces#create'
  get 'spaces', to: 'spaces#index'
  get 'spaces/:id', to: 'spaces#show', as: :space
end

  #root to: 'shelves#index'
  #get 'shelves/new', to: 'shelves#new'
  #post 'shelves', to: 'shelves#create'
  #get 'shelves', to: 'shelves#index'
  #get 'shelves/:id', to: 'shelves#show', as: :shelf
  #get 'shelves/:id/edit', to: 'shelves#edit'
  #patch 'shelves/:id', to: 'shelves#update'
  #delete 'shelves/:id', to: 'shelves#destroy'
