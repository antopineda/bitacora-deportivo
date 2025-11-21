Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"

  resources :games
  resources :dynamics
  resources :applauses
  resources :reflections
  
  # Rutas de ruletas
  get "ruleta", to: "pages#roulette_index", as: :roulette
  get "ruleta/juegos", to: "games#roulette", as: :roulette_games
  get "ruleta/dinamicas", to: "dynamics#roulette", as: :roulette_dynamics
  get "ruleta/aplausos", to: "applauses#roulette", as: :roulette_applauses
  get "ruleta/todo", to: "pages#roulette_all", as: :roulette_all
  
  root "pages#roulette_index"
end
