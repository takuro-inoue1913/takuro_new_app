Rails.application.routes.draw do
  get 'sessions/new'

  root 'landing_pages#home'
  
  get '/help',    to: 'landing_pages#help'
  get '/about',   to: 'landing_pages#about'
  get '/contact', to: 'landing_pages#contact'
  
  get  '/signup',  to: 'users#new'
  post '/signup',  to: 'users#show'
  
  get     '/login', to: 'sessions#new'
  post    '/login', to: 'session#create'
  delete '/logout', to: 'sessions#destroy'
  
  resources :users
  
 root 'application#hello'
end
