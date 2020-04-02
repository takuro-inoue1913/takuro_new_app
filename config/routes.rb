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
  
  get '/auth/:provider/callback',to: 'users#create', as: :auth_callback
  get '/auth/failure',to: 'users#auth_failure',as: :auth_failure

  resources :users do member do
             # /users/:id/...
             get :following, :followers
               end
             end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :edit, :create, :update]
  resources :microposts,          only: [:show, :create, :destroy] do
             resources :comments
             end
  resources :relationships,       only: [:create, :destroy]
  resources :likes,               only: [:create, :destroy]
  
end
