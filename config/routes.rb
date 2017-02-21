Rails.application.routes.draw do
  scope format: false do
    devise_for :users, skip: [:registrations,:sessions]
    devise_scope :user do
      post "/users", :to => "devise/registrations#create", :as => 'devise_users'
    end
    resources :users, :except => [:create]
    resources :projects do
      resources :certificates, :except => [:destroy]
    end
    resources :environments
  end

  root 'root#index'
end
