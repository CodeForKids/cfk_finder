Rails.application.routes.draw do
  devise_for :users

  resources :customers, except: :index do
    resources :kids, except: :index
  end

  root "application#index"
end
