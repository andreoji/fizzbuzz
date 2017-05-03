Rails.application.routes.draw do
  resources :favourites#, only [:index, :new, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
