Rails.application.routes.draw do
  get 'landing_pages/home'

  get 'landing_pages/help'

   root 'application#hello'
end
