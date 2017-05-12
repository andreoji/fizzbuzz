Rails.application.routes.draw do
  #get '/favourites/next' => 'favourites#next'
  #get '/favourites/previous' => 'favourites#previous'
  resources :favourites, except: :show
    #put on: :collection, action: :marked
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'
end
