Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "/auth/register", to: "auth#register"
  post "/auth/login", to: "auth#login"
  get "/me", to: "me#show"

  resources :clients, only: %i[index create show update destroy]
end

