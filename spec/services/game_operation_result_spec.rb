require "rails_helper"

RSpec.describe GameOperationResult do
  let(:game) { Game.new }
  let(:player) { Player.new }

  subject(:result) { described_class.new(game, player) }

  it 'contains the game' do
    expect(result.game).to be(game)
  end

  it 'contains the player' do
    expect(result.acting_player).to be(player)
  end

  context 'successful operation' do
    it 'can be marked as successful' do
      outcome = result.success!
      expect(outcome).to be_successful
    end
  end

  context 'failed operation' do
    it 'can be marked as failed with an explaining message' do
      outcome = result.error! "No space left!"
      expect(outcome).to be_failed
      expect(outcome.error_message).to eql("No space left!")
    end
  end


  # it 'generates randomly the active player' do
  #   games = 10.times.map { described_class.new.build }

  #   player_x_chosen_once = games.find { |g| g.active_player == g.player_x }
  #   expect(player_x_chosen_once).to be

  #   player_o_chosen_once = games.find { |g| g.active_player == g.player_o }
  #   expect(player_o_chosen_once).to be
  # end

end
