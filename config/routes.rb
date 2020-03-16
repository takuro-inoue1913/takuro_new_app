Rails.application.routes.draw do
  get 'password_resets/new'

  get 'password_resets/edit'

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
  
 root 'application#hello'
end
