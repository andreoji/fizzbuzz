Rails.application.routes.draw do
  scope constraints: { format: 'html' } do
    resources :favourites, only: [:index] do
      put '/', on: :collection, action: :update_favourites 
    end
  end

  scope constraints: { format: 'json' } do 
    namespace :api do
      namespace :v1 do
        resources :favourites, only: [:index] do
          put '/', on: :collection, action: :update_favourites
        end
      end
    end
  end

  #resources :favourites do#, except: :show
  #  put on: :collection, action: :update_favourites
  #end
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope constraints: { format: 'html' } do 
    get '/login' => 'sessions#new'
    post '/login' => 'sessions#create'
    get '/logout' => 'sessions#destroy'
  end

  scope constraints: { format: 'json' } do 
    namespace :api do
      namespace :v1 do
        get '/login' => 'sessions#new'
        post '/login' => 'sessions#create'
        get '/logout' => 'sessions#destroy'
      end
    end
  end
end
