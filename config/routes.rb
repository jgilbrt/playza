Rails.application.routes.draw do
  get 'dashboards/index'
  get 'payments/index'
  get 'payments/show'
  get 'awards/create'
  get 'match_players/update'
  get "/dashboard", to: "dashboards#index"


  post 'players/add', to: 'players#add', as: :add_player

  root "dashboards#index"

  get "up" => "rails/health#show", as: :rails_health_check

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :matches, only: [:index, :show] do
    post 'lineup', on: :member       # POST /matches/:id/lineup
    post 'scorers', on: :member      # POST /matches/:id/scorers
    post 'dick_of_the_day', on: :member # POST /matches/:id/dick_of_the_day
    post 'assign_dotd', on: :member

    collection do
      post :end_season
      post :start_new_season
    end
  end

  resources :match_players, only: [:update]

  resources :teams do
    resources :players, only: [:index, :new, :create]
  end

  resources :players, only: [:index, :new, :create, :edit, :update, :destroy]
  resources :payments, only: [:index, :new, :create, :edit, :update, :destroy]

  resources :users, only: [:index, :new, :create, :edit, :update, :destroy] do
    post 'chase_payment', on: :member
  end

  namespace :manager do
    get :dashboard
  end
end
