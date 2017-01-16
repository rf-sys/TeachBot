Rails.application.routes.draw do

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

  # rss
  get 'courses/feed' => 'courses#rss_feed'

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

  namespace :api do
    get 'subscriptions', action: 'subscriptions_pagination'
    get 'users_course_paginates', action: 'user_courses_pagination'
    get 'find/user/username', action: 'find_user_by_username'
    post 'subscribers', action: 'subscribers'
    post 'conversations', action: 'conversations'
    post 'conversations/:id/messages', action: 'conversation_messages'
    post 'notifications/count', action: 'unread_notifications_count'
    post 'notifications', action: 'notifications'
    post 'messages/read', action: 'mark_message_as_read'
    post 'messages/unread/count', action: 'unread_messages_count'
    post 'messages/unread/all', action: 'unread_messages'
    post 'messages/read/all', action: 'mark_all_messages_as_read'
  end

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
