require 'rails_helper'

RSpec.describe 'Games', type: :request do
  shared_examples 'rendered game' do
    it 'matches the schema of a game response' do
      expect(body).to have_key('name')
      expect(body).to have_key('state')
      expect(body).to have_key('board')
      expect(body).to have_key('player_token')
      expect(body).to have_key('next_move_token')
      expect(body).to have_key('created_at')
      expect(body).to have_key('updated_at')
    end
  end

  shared_examples 'rendered error' do
    it 'matches the schema of an error response' do
      expect(body).to have_key('error')
    end
  end

  let(:body) { JSON.parse(response.body) }

  describe 'GET /api/game' do
    let(:game) { Factory.create_game! }
    let(:token) { game.player_x.token }

    context 'with valid player token' do
      before { get "/api/game?player_token=#{token}" }

      it_behaves_like 'rendered game'

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'with invalid player token' do
      before { get "/api/game?player_token=WRONG-TOKEN" }

      it 'returns an error message' do
        expect(body['error']).to eql('No valid player_token provided')
      end

      it 'returns http error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'without player token' do
      before { get "/api/game" }

      it 'returns an error message' do
        expect(body['error']).to eql('No valid player_token provided')
      end

      it 'returns http error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST /api/game' do
    before { post '/api/game' }

    it_behaves_like 'rendered game'

    it 'returns http success' do
      expect(response).to have_http_status(:created)
    end
  end

  describe 'POST /api/join' do
    context 'joining a game that can be joined' do
      let(:game) { Factory.create_game!(state: 'awaiting_join') }

      before { post '/api/join', params: { name: game.name } }

      it_behaves_like 'rendered game'

      it 'returns http success' do
        expect(response).to have_http_status(:created)
      end
    end

    context "trying to join a game that can't be joined" do
      let(:game) { Factory.create_game! }

      before { post '/api/join', params: { name: game.name } }

      it_behaves_like 'rendered error'

      it 'returns an error message' do
        expect(body['error']).to eql('Game does not await another player to join')
      end

      it 'returns http 422 error status' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'using an invalid game name' do
      let(:game) { Factory.create_game!(state: 'awaiting_join') }

      before { post '/api/join', params: { name: 'WRONG-NAME' } }

      it_behaves_like 'rendered error'

      it 'returns an error message' do
        expect(body['error']).to eql('No valid game name provided')
      end

      it 'returns http 404 error status' do
        expect(response).to have_http_status(:not_found)
      end
    end

  end


  describe 'POST /api/move' do
    let(:game) { Factory.create_game!(active_role: "x") }
    let(:token) { game.player_x.token }

    context 'with valid player token and params' do
      let(:params) do
        { field: "1", next_move_token: game.next_move_token }
      end

      before { post "/api/move?player_token=#{token}", params: params }

      it_behaves_like 'rendered game'

      it 'returns http created' do
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid next move token' do
      let(:params) do
        { field: "1", next_move_token: "INVALID-TOKEN" }
      end

      before { post "/api/move?player_token=#{token}", params: params }

      it_behaves_like 'rendered error'

      it 'returns an error message' do
        expect(body['error']).to eql('Invalid next move token')
      end

      it 'returns http error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid field' do
      let(:params) do
        { field: "WRONG-FIELD", next_move_token: game.next_move_token }
      end

      before { post "/api/move?player_token=#{token}", params: params }

      it_behaves_like 'rendered error'

      it 'returns an error message' do
        expect(body['error']).to eql('No valid field to mark provided')
      end

      it 'returns http error' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context 'with invalid player token' do
      before { post "/api/move?player_token=WRONG-TOKEN" }

      it_behaves_like 'rendered error'

      it 'returns an error message' do
        expect(body['error']).to eql('No valid player_token provided')
      end

      it 'returns http error' do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
