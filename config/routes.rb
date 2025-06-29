Rails.application.routes.draw do
  use_doorkeeper
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Uploads
  post "rails/active_storage/direct_uploads",
       to: "overrides/direct_uploads#create"

  # Defines the root path route ("/")
  # root "posts#index"
  namespace :api do
    jsonapi_resources :companies
    jsonapi_resources :credits
    jsonapi_resources :users
    jsonapi_resources :terms
    jsonapi_resources :term_offerings
    jsonapi_resources :payments
    jsonapi_resources :notifications
    get "events", to: "events#index", as: "events"
    namespace :admin do
      resources :staff, only: %i[index show create update destroy]
    end
    post "auth/resend-confirmation-instructions" =>
           "auth#resend_confirmation_instructions"
    get "me", to: "me#me"
  end

  # authentication
  devise_for :users,
             path: "",
             path_names: {
               sign_in: "login",
               sign_out: "logout",
               registration: "signup"
             },
             controllers: {
               sessions: "users/sessions",
               registrations: "users/registrations",
               confirmations: "users/confirmations",
               invitations: "users/invitations"
             }
end
