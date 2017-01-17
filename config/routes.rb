Rails.application.routes.draw do
  devise_for :users
  scope format: false do
    resources :owners do
      resources :certificates
    end
  end

  root 'root#index'
end
