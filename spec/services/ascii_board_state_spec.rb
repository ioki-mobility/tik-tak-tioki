# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AsciiBoardState do
  describe '.encode' do
    it 'can encode a board' do
      result = described_class.encode(%w[x f o f o x o x f])

      expected = ['|---+---+---|',
                  '| x | f | o |',
                  '|---+---+---|',
                  '| f | o | x |',
                  '|---+---+---|',
                  '| o | x | f |',
                  '|---+---+---|']

      expect(result).to eql(expected)
    end
  end

  describe '.decode' do
    it 'can decode a board' do
      result = described_class.decode <<~BOARD
        |---+---+---|
        | x | f | o |
        |---+---+---|
        | f | o | x |
        |---+---+---|
        | o | x | f |
        |---+---+---|
      BOARD

      expect(result).to eql(%w[x f o f o x o x f])
    end

    it 'can decode a board with blank cells' do
      result = described_class.decode <<~BOARD
        |---+---+---|
        | x |   | o |
        |---+---+---|
        |   | o | x |
        |---+---+---|
        | o | x |   |
        |---+---+---|
      BOARD

      expect(result).to eql(%w[x f o f o x o x f])
    end
  end
end
