Rails.application.routes.draw do
  require 'constraints/admin_constraint'
  require 'sidekiq/web'

  root 'main#index'

  post 'user_token' => 'user_token#create'

  get 'bot/help'

  # sign up (message user)
  get 'signup' => 'users#new'

  # sessions (login)
  get 'login' => 'sessions#new'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'

  get 'bot', to: 'api#bot'

  post 'attachment', to: 'attachments#attachment'

  # resources

  resources :account_activations, except: %i[destroy show update]

  resources :users do
    resources :courses, only: %i[index destroy], controller: 'user_controllers/courses' do
      collection do
        get 'subscriptions'
        get 'all', action: 'courses'
      end
    end
    resources :posts, only: [:index], controller: 'user_controllers/posts'
    resources :subscriptions, only: %i[index destroy], controller: 'user_controllers/subscriptions'
  end

  resources :courses do
    resources :lessons, except: [:index], controller: 'course_controllers/lessons'
    # resources :subscribers, only: [:index, :create, :destroy]
    resources :participants, only: %i[index create destroy], controller: 'course_controllers/participants'

    member do
      patch 'poster', action: 'update_poster'
      patch 'publish', action: 'toggle_publish'
    end
  end

  resources :subscriptions, only: %i[create destroy]

  resources :rss, only: [:index]

  resources :account_activations, only: [:edit]

  resources :posts, only: %i[create destroy] do
    collection do
      post 'attachment'
    end
  end

  resources :messages, only: [:create] do
    member do
      post 'read', action: 'mark_as_read'
    end
    collection do
      post 'read/all', action: 'mark_all_as_read'
      post 'unread', action: 'unread_messages'
      post 'unread/count', action: 'unread_messages_count'
    end
  end

  resources :chats do
    resources :messages, only: %i[index create], controller: 'chat_controllers/messages'
    member do
      delete 'leave'
      post 'add_participant'
      delete 'kick_participant'
    end
  end

  resource :public_chat, only: [:show], controller: :public_chat do
    resources :messages, only: %i[index create], controller: 'public_chat_controllers/messages'
  end

  resources :notifications, only: %i[index destroy] do
    collection do
      post 'count'
      put 'mark_as_read'
    end
  end

  resources :search, only: [:index]

  resources :recommendations, only: [:index]

  namespace :auth do
    get 'facebook', action: 'facebook'
    get 'facebook/callback', action: 'auth_callback'
    get 'github', action: 'github'
    get 'github/callback', action: 'auth_callback'
  end

  namespace :api do
    post 'user_token'
    namespace :v1 do
      namespace :users do
        post 'find_by_username'
      end
    end
  end

  mount ActionCable.server => '/cable'

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new
end
