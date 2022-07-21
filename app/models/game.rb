# frozen_string_literal: true

class Game < ApplicationRecord
  BOARD_FIELD_VALUES = %w[x o f].freeze

  has_many :players

  has_secure_token :next_move_token

  enum :state, {
    awaiting_join: 'awaiting_join',
    playing: 'playing',
    win_by_player_x: 'win_by_player_x',
    win_by_player_o: 'win_by_player_o',
    draw: 'draw'
  }

  validates_presence_of :name
  validates_presence_of :state

  validates_presence_of :player_x
  validates_presence_of :player_o
  validates_length_of :players, is: 2

  validates_presence_of :active_player, if: :playing?
  validates_presence_of :active_role, if: :playing?

  validates_presence_of :board
  validates_length_of :board, is: 9
  validate :validate_board_values

  def player_x
    players.find(&:role_x?)
  end

  def player_o
    players.find(&:role_o?)
  end

  def active_player
    players.find { |p| p.role == active_role }
  end

  def self.recently_joinable
    awaiting_join.where('created_at > ?', 5.minutes.ago).order(created_at: :desc)
  end

  private

  def validate_board_values
    valid_values = BOARD_FIELD_VALUES

    return errors.add(:board, :invalid) unless board.is_a?(Array)

    errors.add(:board, :invalid) if board.any? { |f| valid_values.exclude?(f) }
  end
end
