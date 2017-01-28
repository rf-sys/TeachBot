Rails.application.routes.draw do

  post 'user_token' => 'user_token#create'
  get 'courses/index'

  get 'cources/index'

  get 'lessons/index'

  get 'bot/help'

  # sign up (message user)
  get 'signup' => 'users#new'

  # sessions (login)
  get 'login' => 'sessions#new'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'


  get 'bot', to: 'api#bot'

  root 'main#index'

  get 'public_chat', to: 'chats#public_chat'
  get 'conversations', to: 'chats#index'

  # rss
  get 'courses/feed' => 'courses#rss_feed'

  # resources

  resources :account_activations, except: [:destroy, :show, :update]

  resources :users do
    resources :courses, only: [:index], controller: 'user_controllers/courses' do
      collection do
        get 'subscriptions'
        get 'all', action: 'courses'
      end
    end
    resources :posts, only: [:index], controller: 'user_controllers/posts'
  end

  resources :courses do
    resources :lessons, except: [:index]
    resources :subscribers, only: [:index, :create, :destroy]

    member do
      patch 'poster', action: 'update_poster'
      patch 'publish', action: 'toggle_publish'
    end
  end

  resources :account_activations, only: [:edit]

  resources :posts, only: [:create, :destroy]

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
    resources :messages, only: [:index, :create], controller: 'chat_controllers/messages'
    member do
      delete 'leave'
      post 'add_participant'
      delete 'kick_participant'
    end
  end

  resources :notifications, only: [:index, :destroy] do
    collection do
      post 'count'
    end
  end

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
end
