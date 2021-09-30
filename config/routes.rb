Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users, controllers: { sessions: "sessions", registrations: "registrations" }
  root to: 'pages#home'
  get "/payment" => "pages#payment", as: 'payment'
  post "/create-checkout-session" => "payments#redirect_stripe"
  post '/hooks/stripe' => 'payments#receive'
  devise_scope :user do
    get "meet_bot", to: "registrations#meet_bot"
    get "shake_hands", to: "registrations#shake_hands"
    get "add_first_resource", to: "registrations#add_first_resource"
    get "/registrations/stat_telegram_chat_id", to: "registrations#stat_telegram_chat_id"
    get "/registrations/stat_added_first_item", to: "registrations#stat_added_first_item"
    get "/registrations/current_shelf", to: "registrations#current_shelf"
    get "sessions/extension", to: "sessions#new_ext"
    post "sessions/extension", to: "sessions#create_ext"
    get "/sessions/start_extension", to: "sessions#start_extension"
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :items, only: [ :index, :create ]
    end
  end
  resources :registrations, only: [:new, :create] do
    collection do
      get 'stat_telegram_chat_id'
      get 'stat_added_first_item'
      get 'current_shelf'
    end
  end
  resources :shelves, only: [:new, :create, :show], param: :username do
    member do
      get 'shelf_children'
    end
  end
  resources :spaces do
    collection do
      post :move_space_to_space
      post :move_space_to_shelf
    end
    member do
      patch :move
      get 'space_name'
      get 'space_children'
    end
  end
  resources :items do
    collection do
      post :move_to_space
      post :move_to_shelf
      post :persist_mp3_url
    end
    member do
      patch :move
    end
  end
  post '/application/update_balance_temp', to: 'application#update_balance_temp'
  post '/application/update_balance_final', to: 'application#update_balance_final'
  get '/application/user_balance', to: 'application#user_balance'
end
