Rails.application.routes.draw do
  devise_for :users
  
  #for dashboard
  post 'users/dashboard', to:'users#dashboard' #post action will get day view for specified date
  get 'users/dashboard', to:'users#dashboard' #get action will get day view for today's date  
  root "users#dashboard"
  #for invites dashboard
  get 'users/invite', to:'users#invite'

  resources :events
  
  post 'invites/update_status', to:'invites#update_status'
  post 'invites/create_invites', to:'invites#create_invites'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
