class Game < ApplicationRecord
  has_secure_token :next_move_token

  enum :state, {
    waiting_for_other_player: 'waiting_for_other_player',
    player_x_turn: 'player_x_turn',
    player_o_turn: 'player_o_turn',
    player_x_win: 'player_x_win',
    player_o_win: 'player_o_win',
    draw: 'draw'
  }

  validates_presence_of :name
  validates_presence_of :state
  validates_presence_of :board
  validates_length_of :board, is: 9
  validate :validate_board_values


  def validate_board_values
    valid_values = %w(F X O)

    if !board.is_a?(Array)
      return errors.add(:board, :invalid)
    end

    if board.any?{ |f| valid_values.exclude?(f) }
      return errors.add(:board, :invalid)
    end
  end
end
