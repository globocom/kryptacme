Rails.application.routes.draw do
  devise_for :users
  scope format: false do
    resources :projects do
      resources :certificates
    end
  end

  root 'root#index'
end
