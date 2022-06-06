require "rails_helper"

RSpec.describe GameCreator do
  subject { described_class.new }

  it 'builds a valid game' do
    game = subject.build

    expect(game.players.length).to eql(2)
    expect(game).to be_valid
  end

  it 'generates randomly the active player' do
    games = 10.times.map { described_class.new.build }

    player_x_chosen_once = games.find { |g| g.active_player == g.player_x }
    expect(player_x_chosen_once).to be

    player_o_chosen_once = games.find { |g| g.active_player == g.player_o }
    expect(player_o_chosen_once).to be
  end

  it 'generates a persisted' do
    game = subject.create!
    expect(game).to be_persisted
  end
end
