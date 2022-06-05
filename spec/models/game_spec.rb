require 'rails_helper'

RSpec.describe Game, type: :model do
  it { should have_many(:players) }

  describe 'next_move_token' do
    it { should have_secure_token(:next_move_token) }
    it { should have_db_index(:next_move_token).unique(true) }
  end

  describe 'name' do
    it { should have_db_index(:name).unique(true) }
  end

  describe 'board' do
    it 'should be a board with free fields by default' do
      game = Game.new

      expect(game.board).to eql(["F", "F", "F",
                                 "F", "F", "F",
                                 "F", "F", "F"
                                ])
    end
  end

  describe 'state' do
    it do
      should define_enum_for(:state)
        .with_values({
                       waiting_for_other_player: 'waiting_for_other_player',
                       player_x_turn: 'player_x_turn',
                       player_o_turn: 'player_o_turn',
                       player_x_win: 'player_x_win',
                       player_o_win: 'player_o_win',
                       draw: 'draw'
                     }).backed_by_column_of_type(:string)
    end
  end

  describe 'validations' do
    subject(:game) do
      GameCreator.new.build
    end

    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:state) }

    describe 'player validations' do
      it 'does not allow more than two players' do
        expect(game).to be_valid

        game.players.build(role: :x)
        expect(game).not_to be_valid
        expect(game.errors.messages).to have_key :players
      end

      it 'does not allow less than two players' do
        expect(game).to be_valid

        game.players.first.game = nil
        expect(game).not_to be_valid
        expect(game.errors.messages).to have_key :players
      end

      it 'needs a player with role x' do
        expect(game).to be_valid

        game.player_x.role = nil
        expect(game).not_to be_valid
        expect(game.errors.messages).to have_key :player_x
      end

      it 'needs a player with role o' do
        expect(game).to be_valid

        game.player_o.role = nil
        expect(game).not_to be_valid
        expect(game.errors.messages).to have_key :player_o
      end
    end

    describe 'board validations' do
      it { should validate_presence_of(:board) }

      it 'only allows a length of 9 for the board' do
        expect(game).to be_valid

        # set 10 fields
        game.board = ("F" * 10).split("")
        expect(game).not_to be_valid

        # set 8 fields
        game.board = ("F" * 8).split("")
        expect(game).not_to be_valid

        # set 9 fields
        game.board = ("F" * 9).split("")
        expect(game).to be_valid
      end

      it 'only allows f, x and o as values' do
        expect(game).to be_valid

        game.board[1] = "X"
        expect(game).to be_valid

        game.board[1] = "O"
        expect(game).to be_valid

        game.board[1] = nil
        expect(game).not_to be_valid

        game.board[1] = ""
        expect(game).not_to be_valid

        %w(A Z $ 0 1).each do |value|
          game.board[1] = value
          expect(game).not_to be_valid
        end
      end
    end

    describe 'active_player' do
      subject(:game) do
        GameCreator.new.build
      end

      it 'returns player x when the active role is x' do
        game.active_role = "x"
        expect(game.active_player).to eql(game.player_x)
      end

      it 'returns player o when the active role is o' do
        game.active_role = "o"
        expect(game.active_player).to eql(game.player_o)
      end
    end
  end
end
