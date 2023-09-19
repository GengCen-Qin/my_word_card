Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "words#index"
  # Defines the root path route ("/")
  # root "articles#index"
  resources :words
end
