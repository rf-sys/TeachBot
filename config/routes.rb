Rails.application.routes.draw do

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

  # sign up (create user)
  get 'signup' => 'users#new'


  # sessions (login)
  get 'login' => 'sessions#new'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'


  get 'bot', to: 'api#bot'

  root 'main#index'

  # resources

  resources :users do
    resources :courses, only: [:index], controller: 'user/courses'
    resources :posts, only: [:index], controller: 'user/posts'
  end

  resources :courses do
    resources :lessons, except: [:index]
    resources :subscribers, only: [:create, :destroy]
  end

  resources :account_activations, only: [:edit]

  resources :posts, only: [:create, :destroy]



  resources :chat do
    resources :messages, only: [:create]
  end

  get 'oauth/facebook', to: 'api#facebook_oauth'
  get 'api/subscriptions', to: 'api#subscriptions_pagination'
  get 'api/users_course_paginates', to: 'api#user_courses_pagination'
  get 'api/find/user/username', to: 'api#find_user_by_username'
  post 'api/subscribers', to: 'api#subscribers'

  mount ActionCable.server => '/cable'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
