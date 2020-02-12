Rails.application.routes.draw do

  post '/signup' => 'users#create'
  post '/login' => 'sessions#create'

end
