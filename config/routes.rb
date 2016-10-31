Rails.application.routes.draw do

  # sign up (create user)
  get 'signup'  => 'users#new'


  # sessions (login)
  get 'login' => 'sessions#new'

  post 'login' => 'sessions#create'

  delete 'logout' => 'sessions#destroy'


  get 'lessons',  to: 'lessons#index', as: 'lessons_index'

  root 'main#index'

  # resources

  resources :users, except: [:edit]


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
