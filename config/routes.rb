Rails.application.routes.draw do

  namespace :user do
    get 'notifications/index'
  end

  namespace :user do
    get 'messages/create'
  end

  namespace :chat do
    get 'messages/create'
  end

  namespace :user do
    get 'posts/index'
  end

  namespace :user do
    get 'lessons/index'
  end

  namespace :user do
    get 'courses/index'
  end

  get 'courses/index'

  get 'cources/index'

  get 'lessons/index'

  get 'bot/help'

  get 'account_activations/edit'

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

  # resources

  resources :users do
    resources :courses, only: [:index], controller: 'user_controllers/courses'
    resources :posts, only: [:index], controller: 'user_controllers/posts'
  end

  resources :courses do
    resources :lessons, except: [:index]
    resources :subscribers, only: [:create, :destroy]
  end

  resources :account_activations, only: [:edit]

  resources :posts, only: [:create, :destroy]

  resources :messages, only: [:create]

  resources :chats do
    resources :messages, only: [:create], controller: 'chat_controllers/messages'
  end

  resources :notifications, only: [:destroy]

  get 'oauth/facebook', to: 'api#facebook_oauth'
  get 'api/subscriptions', to: 'api#subscriptions_pagination'
  get 'api/users_course_paginates', to: 'api#user_courses_pagination'
  get 'api/find/user/username', to: 'api#find_user_by_username'
  post 'api/subscribers', to: 'api#subscribers'
  post 'api/conversations', to: 'api#conversations'
  post 'api/conversations/:id/messages', to: 'api#conversation_messages'
  post 'api/notifications/count', to: 'api#unread_notifications_count'
  post 'api/notifications', to: 'api#notifications'

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
