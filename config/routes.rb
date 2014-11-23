Rails.application.routes.draw do
  resources :tutors, except: :index

  devise_for :users

  resources :parents, except: :index do
    resources :kids, except: :index
  end

  root "home#index"
  controller :home do
    get :json_markers, to: :json_markers
    post :auth_token, to: :authenticate
  end

end
