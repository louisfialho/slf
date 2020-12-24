Rails.application.routes.draw do
  devise_for :users
  root to: "shelves#index"
  resources :shelves
  resources :spaces, only: [:new, :create, :index, :show]
  get 'spaces/:id/edit', to: 'spaces#edit'
  patch 'spaces/:id', to: 'spaces#update'
  delete 'spaces/:id', to: 'spaces#destroy'
end

  #root to: 'shelves#index'
  #get 'shelves/new', to: 'shelves#new'
  #post 'shelves', to: 'shelves#create'
  #get 'shelves', to: 'shelves#index'
  #get 'shelves/:id', to: 'shelves#show', as: :shelf
  #get 'shelves/:id/edit', to: 'shelves#edit'
  #patch 'shelves/:id', to: 'shelves#update'
  #delete 'shelves/:id', to: 'shelves#destroy'
