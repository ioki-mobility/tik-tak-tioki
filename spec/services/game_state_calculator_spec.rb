# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GameStateCalculator do
  subject(:new_state) { described_class.new(game).new_state }

  context 'game is not in playing state' do
    let(:game) { Game.new(state: 'draw') }

    it 'just returns the existing state' do
      expect(new_state).to eql('draw')
    end
  end

  context 'game can continue' do
    let(:game) do
      Factory.create_game! do
        <<~BOARD
          |---+---+---|
          | x |   | o |
          |---+---+---|
          |   |   | x |
          |---+---+---|
          | o | x |   |
          |---+---+---|
        BOARD
      end
    end

    it 'keeps the game in playing state' do
      expect(new_state).to eql('playing')
    end
  end

  context 'x wins' do
    describe 'x wins by 3 horizontal marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            |   |   | o |
            |---+---+---|
            | x | x | x |
            |---+---+---|
            | o |   |   |
            |---+---+---|
          BOARD
        end
      end

      it 'returns x as winner' do
        expect(new_state).to eql('win_by_player_x')
      end
    end

    describe 'x wins by 3 vertical marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            |   | o | x |
            |---+---+---|
            |   | o | x |
            |---+---+---|
            | o |   | x |
            |---+---+---|
          BOARD
        end
      end

      it 'returns x as winner' do
        expect(new_state).to eql('win_by_player_x')
      end
    end

    describe 'x wins by 3 diagonal marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            |   | o | x |
            |---+---+---|
            |   | x |   |
            |---+---+---|
            | x |   | o |
            |---+---+---|
          BOARD
        end
      end

      it 'returns x as winner' do
        expect(new_state).to eql('win_by_player_x')
      end
    end
  end

  context 'o wins' do
    describe 'o wins by 3 horizontal marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            |   |   | x |
            |---+---+---|
            |   | x |   |
            |---+---+---|
            | o | o | o |
            |---+---+---|
          BOARD
        end
      end

      it 'returns o as winner' do
        expect(new_state).to eql('win_by_player_o')
      end
    end

    describe 'o wins by 3 vertical marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            | o | x | x |
            |---+---+---|
            | o |   |   |
            |---+---+---|
            | o |   |   |
            |---+---+---|
          BOARD
        end
      end

      it 'returns o as winner' do
        expect(new_state).to eql('win_by_player_o')
      end
    end

    describe 'o wins by 3 diagonal marks' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            | o | x |   |
            |---+---+---|
            |   | o |   |
            |---+---+---|
            | x |   | o |
            |---+---+---|
          BOARD
        end
      end

      it 'returns o as winner' do
        expect(new_state).to eql('win_by_player_o')
      end
    end
  end

  context 'draw' do
    describe 'board is full with no winner' do
      let(:game) do
        Factory.create_game! do
          <<~BOARD
            |---+---+---|
            | o | x | o |
            |---+---+---|
            | x | o | x |
            |---+---+---|
            | x | o | x |
            |---+---+---|
          BOARD
        end
      end

      it 'returns draw state' do
        expect(new_state).to eql('draw')
      end
    end
  end
end
