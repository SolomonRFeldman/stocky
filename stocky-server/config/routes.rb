Rails.application.routes.draw do

  post '/signup' => 'users#create'
  post '/login' => 'sessions#create'

  resources :users, only: [:show] do
    resources :user_stocks, only: [:create]
  end

end
