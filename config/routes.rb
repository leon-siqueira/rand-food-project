Rails.application.routes.draw do
  root to: 'pages#home'
  resources :moods
  # resource :moods, only: %i[show, edit, update, destroy]
  resources :results, only: %i[index]
  get 'results/show', to: 'results#show', as: 'result'
  get 'about', to: 'pages#about', as: :about

  devise_for :users

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
