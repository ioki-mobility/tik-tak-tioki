class GameStateCalculator
  attr_accessor :game

  ROWS = [
    [0, 1, 2],
    [3, 4, 5],
    [6, 7, 8]
  ]

  COLUMNS = [
    ROWS.map(&:first),
    ROWS.map(&:second),
    ROWS.map(&:third)
  ]

  DIAGONALS = [
    [ROWS.first.first, ROWS.second.second, ROWS.third.third],
    [ROWS.first.third, ROWS.second.second, ROWS.third.first]
  ]

  def initialize(game)
    self.game = game
  end

  def new_state
    if !game.playing?
      return game.state
    end

    if player_won?("x")
      Game.states[:win_by_player_x]
    elsif player_won?("o")
      Game.states[:win_by_player_o]
    elsif all_fields_taken?
      Game.states[:draw]
    else
      Game.states[:playing]
    end
  end

  def player_won?(role)
    won_horizontally?(role) || won_vertically?(role) || won_diagonally?(role)
  end

  def won_horizontally?(role)
    three_in_row?(ROWS, role)
  end

  def won_vertically?(role)
    three_in_row?(COLUMNS, role)
  end

  def won_diagonally?(role)
    three_in_row?(DIAGONALS, role)
  end

  def three_in_row?(lists, role)
    lists.any? do |indices|
      indices.all? { |index| game.board[index] == role }
    end
  end

  def all_fields_taken?
    game.board.none? { |val| val == 'f' }
  end
end
