require 'rails_helper'

RSpec.describe "Debugger", type: :request do
  describe "GET /debugger" do
    it 'loads the page' do
      get '/debugger'
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /debugger/<player_token>" do
    let(:game) { Factory.create_game! }
    let(:token) { game.player_x.token }

    describe 'when a valid player token is provided' do
      it 'loads the page' do
        get "/debugger/#{token}"
        expect(response).to have_http_status(:success)
      end
    end

    describe 'when no valid player token is provided' do
      it 'raises a 404 error' do
        get "/debugger/INVALID-TOKEN"
        expect(response).to redirect_to(debugger_index_path)
        expect(flash[:alert]).to eql("Invalid Player Token")
      end
    end
  end
end
