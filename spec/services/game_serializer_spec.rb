# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameSerializer do
  shared_examples 'a rendered game with default values' do
    it 'renders the name' do
      expect(subject[:name]).to eql(game.name)
      expect(subject[:name]).to be_a(String)
    end

    it 'renders timestamps' do
      expect(subject[:created_at]).to eql(game.created_at)
      expect(subject[:created_at]).to be_a(ActiveSupport::TimeWithZone)
      expect(subject[:updated_at]).to eql(game.updated_at)
      expect(subject[:updated_at]).to be_a(ActiveSupport::TimeWithZone)
    end

    it 'renders board' do
      expect(subject[:board]).to eql(game.board)
      expect(subject[:board].length).to eql(9)
    end
  end

  let!(:game) { Factory.create_game! }

  context 'for player x' do
    subject(:result) { described_class.new(game, game.player_x).as_json }

    context 'when the game was created and is awaiting player o' do
      before { game.awaiting_join! }

      it_behaves_like 'a rendered game with default values'

      it 'is awaiting the other player' do
        expect(result[:state]).to eql('awaiting_join')
      end

      it 'renders the player_role for player x' do
        expect(result[:player_role]).to eql('x')
      end

      it 'renders the player_token for player x' do
        expect(result[:player_token]).to eql(game.player_x.token)
      end

      it 'does not render next_move_token' do
        expect(result[:next_move_token]).to be_nil
      end
    end

    context 'when the game was joined' do
      describe 'and it is player x turn' do
        before { game.active_role = 'x' }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('your_turn')
        end

        it 'renders the player_role for player x' do
          expect(result[:player_role]).to eql('x')
        end

        it 'renders the player_token for player x' do
          expect(result[:player_token]).to eql(game.player_x.token)
        end

        it 'renders next_move_token' do
          expect(result[:next_move_token]).to eql(game.next_move_token)
        end
      end

      describe 'and it is player o turn' do
        before { game.active_role = 'o' }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('their_turn')
        end

        it 'renders the player_role for player x' do
          expect(result[:player_role]).to eql('x')
        end

        it 'renders the player_token for player x' do
          expect(result[:player_token]).to eql(game.player_x.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end
    end

    describe 'game ended' do
      describe 'player x won' do
        before { game.win_by_player_x! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('you_won')
        end

        it 'renders the player_role for player x' do
          expect(result[:player_role]).to eql('x')
        end

        it 'renders the player_token for player x' do
          expect(result[:player_token]).to eql(game.player_x.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end

      describe 'player o won' do
        before { game.win_by_player_o! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('they_won')
        end

        it 'renders the player_role for player x' do
          expect(result[:player_role]).to eql('x')
        end

        it 'renders the player_token for player x' do
          expect(result[:player_token]).to eql(game.player_x.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end

      describe 'draw' do
        before { game.draw! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('draw')
        end

        it 'renders the player_role for player x' do
          expect(result[:player_role]).to eql('x')
        end

        it 'renders the player_token for player x' do
          expect(result[:player_token]).to eql(game.player_x.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end
    end
  end

  context 'for player o' do
    subject(:result) { described_class.new(game, game.player_o).as_json }

    context 'when the game was joined' do
      describe 'and it is player x turn' do
        before { game.active_role = 'x' }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('their_turn')
        end

        it 'renders the player_role for player o' do
          expect(result[:player_role]).to eql('o')
        end

        it 'renders the player_token for player o' do
          expect(result[:player_token]).to eql(game.player_o.token)
        end

        it 'renders next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end

      describe 'and it is player o turn' do
        before { game.active_role = 'o' }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('your_turn')
        end

        it 'renders the player_role for player o' do
          expect(result[:player_role]).to eql('o')
        end

        it 'renders the player_token for player o' do
          expect(result[:player_token]).to eql(game.player_o.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to eql(game.next_move_token)
        end
      end
    end

    describe 'game ended' do
      describe 'player x won' do
        before { game.win_by_player_x! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('they_won')
        end

        it 'renders the player_role for player o' do
          expect(result[:player_role]).to eql('o')
        end

        it 'renders the player_token for player o' do
          expect(result[:player_token]).to eql(game.player_o.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end

      describe 'player o won' do
        before { game.win_by_player_o! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('you_won')
        end

        it 'renders the player_role for player o' do
          expect(result[:player_role]).to eql('o')
        end

        it 'renders the player_token for player o' do
          expect(result[:player_token]).to eql(game.player_o.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end

      describe 'draw' do
        before { game.draw! }

        it_behaves_like 'a rendered game with default values'

        it 'is awaiting the other player' do
          expect(result[:state]).to eql('draw')
        end

        it 'renders the player_role for player o' do
          expect(result[:player_role]).to eql('o')
        end

        it 'renders the player_token for player o' do
          expect(result[:player_token]).to eql(game.player_o.token)
        end

        it 'does not render next_move_token' do
          expect(result[:next_move_token]).to be_nil
        end
      end
    end
  end
end
