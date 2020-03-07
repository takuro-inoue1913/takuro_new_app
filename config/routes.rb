Rails.application.routes.draw do
  root 'landing_pages#home'
  
  get '/help',    to: 'landing_pages#help'
  get '/about',   to: 'landing_pages#about'
  get '/contact', to: 'landing_pages#contact'
  get  '/signup',  to: 'users#new'
  resources :users
  
 root 'application#hello'
end
