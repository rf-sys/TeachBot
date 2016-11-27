Rails.application.routes.draw do

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

  resources :users, except: [:edit]
  resources :lessons
  resources :account_activations, only: [:edit]


  get 'oauth/facebook', to: 'api#facebook_oauth'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
