Rails.application.routes.draw do
  get 'subscriptions/create'

  get 'subscriptions/destroy'

  require 'constraints/admin_constraint'
  require 'sidekiq/web'

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

  # resources

  resources :account_activations, except: [:destroy, :show, :update]

  resources :users do
    resources :courses, only: [:index, :destroy], controller: 'user_controllers/courses' do
      collection do
        get 'subscriptions'
        get 'all', action: 'courses'
      end
    end
    resources :posts, only: [:index], controller: 'user_controllers/posts'
    resources :subscriptions, only: [:index, :destroy], controller: 'user_controllers/subscriptions'
  end

  resources :courses do
    resources :lessons, except: [:index], controller: 'course_controllers/lessons'
    #resources :subscribers, only: [:index, :create, :destroy]
    resources :participants, only: [:index, :create, :destroy], controller: 'course_controllers/participants'

    member do
      patch 'poster', action: 'update_poster'
      patch 'publish', action: 'toggle_publish'
    end
  end

  resources :subscriptions, only: [:create, :destroy]

  resources :rss, only: [:index]

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

  resource :public_chat, only: [:show], controller: :public_chat do
    resources :messages, only: [:index, :create], controller: 'public_chat_controllers/messages'
  end

  resources :notifications, only: [:index, :destroy] do
    collection do
      post 'count'
      put 'mark_all_as_read'
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

  mount Sidekiq::Web => '/sidekiq', constraints: AdminConstraint.new

end
