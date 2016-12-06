Rails.application.routes.draw do

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
  end

  resources :courses do
    resources :lessons, except: [:index]
  end

  resources :account_activations, only: [:edit]


  get 'oauth/facebook', to: 'api#facebook_oauth'
  get 'api/subscriptions', to: 'api#subscriptions_pagination'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
