Rails.application.routes.draw do
  resources :kids

  resources :customers
  root "customers#index"
end
