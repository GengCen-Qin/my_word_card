Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root "words#index"

  resources :words, only: [:index, :destroy]

  post '/word/search', to: 'words#search'
end
