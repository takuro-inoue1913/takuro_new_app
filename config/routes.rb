Rails.application.routes.draw do
  get 'landing_pages/home'
  get 'landing_pages/help'
  get 'landing_pages/about'

   root 'application#hello'
end
