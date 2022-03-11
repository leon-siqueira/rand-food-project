Rails.application.routes.draw do
  get 'moods/index'
  get 'moods/show'
  get 'moods/create'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
