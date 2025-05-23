Rails.application.routes.draw do
  get 'dashboards/index'
  get 'payments/index'
  get 'payments/show'
  get 'players/index'
  get 'players/show'
  get 'awards/create'
  get 'match_players/update'
  get 'matches/index'
  get 'matches/show'
  get 'matches/lineup'
  get "/dashboard", to: "dashboards#index"


  root "dashboards#index"

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

devise_for :users, controllers: { registrations: 'users/registrations' }

resources :matches do
  member do
    get :lineup       # for one match
    post :set_lineup
    post :set_awards
  end

  collection do
    post :end_season       # for all matches / the season
    post :start_new_season
  end

  resources :match_players, only: [:update]
end

resources :teams, only: [:edit, :update, :show, :index]

resources :players, only: [:index, :new, :create, :edit, :update, :destroy]
resources :payments, only: [:index, :new, :create, :edit, :update, :destroy]

resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
  post 'chase_payment', on: :member
end


namespace :manager do
  get :dashboard
end

  # Defines the root path route ("/")
  # root "posts#index"
end
