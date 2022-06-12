Rails.application.routes.draw do
  scope :api, as: "api" do
    defaults format: :json do
      get '/game', controller: :games, action: :show
      post '/game', controller: :games, action: :create
      post '/join', controller: :games, action: :join
      post '/move', controller: :games, action: :move
    end
  end

  root "docs#index"
end
