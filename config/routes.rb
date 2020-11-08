Rails.application.routes.draw do
  devise_for :users
  post 'home/index', to:'home#index', as: 'dashboard'
  root "home#index"
  
  resources :events
  resources :invites, only: [:index]
  post 'invites/update_status', to:'invites#update_status'
  post 'invites/create_invites', to:'invites#create_invites'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
