require "rails_helper"

RSpec.describe GameUpdater do
  let!(:game) { Factory.create_game! }

  let(:params) do
    { next_move_token: game.next_move_token, field: 1 }
  end

  context 'when updating is not allowed' do
    it 'fails when the game is not playing' do
      expect(game).to receive(:playing?).and_return(false)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Game is not playing")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.active_player)
    end

    it 'fails when the wrong player is not playing' do
      expect(game).to receive(:active_player).at_least(:once).and_return(game.player_o)
      result = described_class.new(game, game.player_x, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("It's not the players turn")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.player_x)
    end

    it 'fails when no next_move token is given' do
      params.delete(:next_move_token)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("No next move token provided")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.active_player)
    end

    it 'fails when wrong next_move token is given' do
      params[:next_move_token] = "WRONG-TOKEN"
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Invalid next move token")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.active_player)
    end

    it 'fails when no field to mark is given' do
      params.delete(:field)
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("No valid field to mark provided")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.active_player)
    end

    it 'fails when field to mark is taken' do
      game.board[1] = "x"
      result = described_class.new(game, game.active_player, params).update!

      expect(result).to be_failed
      expect(result.error_message).to eql("Field is not free")

      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.active_player)
    end
  end

  context 'when updating is allowed and game continues' do
    let(:game) do
      Factory.create_game!(active_role: "x") do
        <<~BOARD
          |---+---+---|
          | x |   | o |
          |---+---+---|
          |   |   |   |
          |---+---+---|
          | o | x |   |
          |---+---+---|
        BOARD
      end
    end

    let(:result) do
      described_class.new(game, game.player_x, params).update!
    end

    it 'is successful' do
      expect(result).to be_successful
      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.player_x)
    end

    it 'persists the game' do
      expect(result.game).to be_persisted
    end

    it 'updates the board' do
      expected_board = AsciiBoardState.decode <<~BOARD
        |---+---+---|
        | x | x | o |
        |---+---+---|
        |   |   |   |
        |---+---+---|
        | o | x |   |
        |---+---+---|
      BOARD

      expect(result.game.board).to eql(expected_board)
    end

    it 'keeps the game state' do
      expect(result.game).to be_playing
    end


    it 'regenerates the next move token' do
      expect(result.game.next_move_token).not_to eql(params[:next_move_token])
    end

    it 'swaps the active player' do
      expect(result.game.active_player).to eql(game.player_o)
    end
  end

  context 'when updating is allowed and game ends with win' do
    let(:game) do
      Factory.create_game!(active_role: "o") do
        <<~BOARD
          |---+---+---|
          | o |   | o |
          |---+---+---|
          |   |   |   |
          |---+---+---|
          | x | x |   |
          |---+---+---|
        BOARD
      end
    end

    let(:result) do
      described_class.new(game, game.player_o, params).update!
    end

    it 'is successful' do
      expect(result).to be_successful
      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.player_o)
    end

    it 'persists the game' do
      expect(result.game).to be_persisted
    end

    it 'updates the board' do
      expected_board = AsciiBoardState.decode <<~BOARD
        |---+---+---|
        | o | o | o |
        |---+---+---|
        |   |   |   |
        |---+---+---|
        | x | x |   |
        |---+---+---|
      BOARD

      expect(result.game.board).to eql(expected_board)
    end

    it 'updates the game state' do
      expect(result.game).to be_win_by_player_o
    end

    it 'regenerates the next move token' do
      expect(result.game.next_move_token).not_to eql(params[:next_move_token])
    end

    it 'removes the active player' do
      expect(result.game.active_player).to be_nil
    end
  end

  context 'when updating is allowed and game ends with draw' do
    let(:game) do
      Factory.create_game!(active_role: "x") do
        <<~BOARD
          |---+---+---|
          | o |   | o |
          |---+---+---|
          | o | x | x |
          |---+---+---|
          | x | o | o |
          |---+---+---|
        BOARD
      end
    end

    let(:result) do
      described_class.new(game, game.player_x, params).update!
    end

    it 'is successful' do
      expect(result).to be_successful
      expect(result.game).to be(game)
      expect(result.acting_player).to be(game.player_x)
    end

    it 'persists the game' do
      expect(result.game).to be_persisted
    end

    it 'updates the board' do
      expected_board = AsciiBoardState.decode <<~BOARD
        |---+---+---|
        | o | x | o |
        |---+---+---|
        | o | x | x |
        |---+---+---|
        | x | o | o |
        |---+---+---|
      BOARD

      expect(result.game.board).to eql(expected_board)
    end

    it 'updates the game state' do
      expect(result.game).to be_draw
    end

    it 'regenerates the next move token' do
      expect(result.game.next_move_token).not_to eql(params[:next_move_token])
    end

    it 'removes the active player' do
      expect(result.game.active_player).to be_nil
    end
  end
end
