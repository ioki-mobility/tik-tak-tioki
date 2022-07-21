Rails.application.routes.draw do
  scope :api, as: "api" do
    defaults format: :json do
      get '/game', controller: :games, action: :show
      post '/game', controller: :games, action: :create
      get '/join', controller: :games, action: :joinable_games
      post '/join', controller: :games, action: :join
      post '/move', controller: :games, action: :move
    end
  end

  resources :debugger, only: [:index, :show], param: :player_token do
    collection do
      post 'view_game'
    end
  end

  root "docs#index"
end
