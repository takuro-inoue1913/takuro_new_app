Rails.application.routes.draw do
  
  root 'landing_pages#home'
  
  get '/help',    to: 'landing_pages#help'
  get '/about',   to: 'landing_pages#about'
  get '/contact', to: 'landing_pages#contact'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#show'
  
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'
  
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :edit, :create, :update]
  resources :microposts,          only: [:create, :destroy]
  
 root 'application#hello'
end
