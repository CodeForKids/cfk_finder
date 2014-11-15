Rails.application.routes.draw do
  devise_for :users
  resources :kids, except: :index
  resources :customers, except: :index

  root "application#index"
end
