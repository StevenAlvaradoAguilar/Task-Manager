Rails.application.routes.draw do
  namespace :api do
    # Ruta para listar todas las características con paginación
    get '/features', to: 'features#index'
    # Ruta para mostrar una característica específica
    get '/features/:id', to: 'features#show'
    # Ruta para crear un comentario para una característica específica
    post '/api/features/:id/create_comment', to: 'features#create_comment', as: 'create_comment'
    # get '/static/js/bundle.js', to: 'application#bundle'
    get "/main.00917910f12e074c60f6.hot-update.js", to: redirect("/404")
    resources :features, only: [:index, :show] do
      post '/api/features/:id/comments', to: 'comments#create', as: 'create_comment'
      resources :comments, only: [:index]
    end
    resources :features, only: [] do
      post 'create_comment', on: :member
    end
  end

  # Ruta raíz de la aplicación
  root 'features#index'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end

# GET /api/features: Lista todas las características.
# GET /api/features/:id: Muestra una característica específica.
# POST /api/features/:id/create_comment: Crea un comentario para una característica específica.
