Rails.application.routes.draw do
  require "sidekiq/web"
  authenticate :user, ->(user) { user.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
  devise_for :users, controllers: {sessions: "sessions", registrations: "custom_registrations"}
  root to: 'pages#home'
  get "/payment" => "pages#payment", as: 'payment'
  post "/create-checkout-session" => "payments#redirect_stripe"
  # post '/hooks/stripe' => 'payments#receive'
  post '/webhook_events/:source', to: 'webhook_events#create'
  devise_scope :user do
    get "meet_bot", to: "telegram_set_up#meet_bot"
    get "shake_hands", to: "telegram_set_up#shake_hands"
    get "add_first_resource", to: "telegram_set_up#add_first_resource"
    get "/telegram_set_up/stat_telegram_chat_id", to: "telegram_set_up#stat_telegram_chat_id"
    get "/telegram_set_up/stat_added_first_item", to: "telegram_set_up#stat_added_first_item"
    get "/telegram_set_up/current_shelf", to: "telegram_set_up#current_shelf"
    get "sessions/extension", to: "sessions#new_ext"
    post "sessions/extension", to: "sessions#create_ext"
    get "/sessions/start_extension", to: "sessions#start_extension"
  end
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :items, only: [ :index, :create ]
    end
  end
  resources :telegram_set_up, only: [:new, :create] do
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
      post :persist_audio_timestamp
      post :persist_audio_duration
      post :mark_as_finished
      get 'item_audio_duration'
      get 'was_item_added'
    end
    member do
      patch :move
    end
  end
  post '/application/update_balance_temp', to: 'application#update_balance_temp'
  post '/application/update_balance_final', to: 'application#update_balance_final'
  post '/application/pay_back_balance', to: 'application#pay_back_balance'
  get '/application/user_balance', to: 'application#user_balance'
end
