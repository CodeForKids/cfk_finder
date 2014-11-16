Rails.application.routes.draw do
  resources :tutors

  devise_for :users

  resources :parents, except: :index do
    resources :kids, except: :index
  end

  root "application#index"
end
