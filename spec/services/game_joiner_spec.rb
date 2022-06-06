require "rails_helper"

RSpec.describe GameJoiner do
  let(:game) { GameCreator.new.create!.game }
  subject (:result) { described_class.new(game).join! }

  context 'game can be joined' do
    it 'responds with a positive result' do
      expect(result).to be_successful
    end

    it 'always sets player o as the acting player' do
      expect(result.acting_player).to be(game.player_o)
    end

    it 'sets the game correctly on the result' do
      expect(result.game).to be(game)
    end

    it 'sets the game to playing state' do
      expect(result.game).to be_playing
    end

    it 'randomly assigns the active player' do
      games = 10.times.map do
        game = GameCreator.new.create!.game
        described_class.new(game).join!
      end.map(&:game)

      player_x_chosen_once = games.find { |g| g.active_player == g.player_x }
      expect(player_x_chosen_once).to be

      player_o_chosen_once = games.find { |g| g.active_player == g.player_o }
      expect(player_o_chosen_once).to be
    end
  end

  context 'game can not be joined' do
    before do
      expect(game).to receive(:awaiting_join?).and_return(false)
    end

    it 'responds with a failed result' do
      expect(result).to be_failed
      expect(result.error_message).to eql("Game does not await another player to join")
    end

    it 'does not set an acting player, to not leak any information' do
      expect(result.acting_player).to be_nil
    end

    it 'does not alter the game' do
      expect(result.game.active_role).to be_nil
    end
  end
end
