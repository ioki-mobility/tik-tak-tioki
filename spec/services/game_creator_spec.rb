# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameCreator do
  subject { described_class.new }

  describe 'build' do
    it 'builds a valid game' do
      game = subject.build

      expect(game.players.length).to eql(2)
      expect(game).to be_valid
    end

    it 'does not set an active player' do
      game = subject.build

      expect(game.active_player).to be_nil
    end
  end

  describe 'create!' do
    subject(:result) { described_class.new.create! }

    it 'responds with a positive result' do
      expect(result).to be_successful
    end

    it 'always sets player x as the acting player', product_decision: true do |example|
      expect(result.acting_player).to be(result.game.player_x)
      expect(example).to be_a_product_decision
    end

    it 'generates a persisted game' do
      expect(result.game).to be_persisted
    end

    it 'sets the game to awaiting_join state' do
      expect(result.game).to be_awaiting_join
    end
  end
end
