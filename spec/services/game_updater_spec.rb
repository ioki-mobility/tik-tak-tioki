require "rails_helper"

RSpec.describe GameUpdater do
  let!(:game) do
    GameCreator.new.create!.tap do |result|
      GameJoiner.new(result.game).join!.game
    end.game
  end

  let(:params) do
    { next_move_token: game.next_move_token, field: 1 }
  end

  context 'when updating is not allowed' do
    it 'fails when the game is not playing' do
      expect(game).to receive(:playing?).and_return(false)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Game is not playing")
    end

    it 'fails when the wrong player is not playing' do
      expect(game).to receive(:active_player).at_least(:once).and_return("o")
      result = described_class.new(game, game.player_x, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("It's not the players turn")
    end

    it 'fails when no next_move token is given' do
      params.delete(:next_move_token)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("No next move token provided")
    end

    it 'fails when wrong next_move token is given' do
      params[:next_move_token] = "WRONG-TOKEN"
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Invalid next move token")
    end

    it 'fails when field to mark is given' do
      params.delete(:field)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("No field to mark provided")
    end

    it 'fails when field to mark is given' do
      game.board[1] = "x"
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Field is not free")
    end
  end
end
