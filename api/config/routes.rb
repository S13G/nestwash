Rails.application.routes.draw do
  # OTP routes
  resources :otps, only: [] do
    collection do
      post :create_otp
      post :verify_otp
    end
  end

  # Registration and Login
  resources :users, only: [] do
    collection do
      post :register
      post :login
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # For monitoring jobs
  require "sidekiq/web"
  mount Sidekiq::Web => "/sidekiq"
  # Defines the root path route ("/")
  # root "posts#index"
end
