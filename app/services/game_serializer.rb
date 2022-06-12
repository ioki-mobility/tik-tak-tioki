class GameSerializer
  attr_accessor :game, :acting_player

  def initialize(game, acting_player)
    self.game = game
    self.acting_player = acting_player
  end

  def as_json(*)
    {
      name: game.name,
      state: state,
      board: game.board,
      player_token: player_token,
      next_move_token: next_move_token,
      created_at: game.created_at,
      updated_at: game.updated_at
    }
  end

  private

  def state
    if game.awaiting_join?
      "awaiting_join"
    elsif game.playing? && is_active_player?
      "your_turn"
    elsif game.playing? && !is_active_player?
      "their_turn"
    elsif acting_player_won?
      "you_won"
    elsif other_player_won?
      "they_won"
    elsif game.draw?
      "draw"
    else
      nil
    end
  end

  def next_move_token
    if game.playing? && is_active_player?
      game.next_move_token
    else
      nil
    end
  end

  def player_token
    acting_player.token
  end

  def is_active_player?
    acting_player == game.active_player
  end

  def acting_player_won?
    if game.win_by_player_x? && acting_player == game.player_x
      true
    elsif game.win_by_player_o? && acting_player == game.player_o
      true
    else
      false
    end
  end

  def other_player_won?
    if game.win_by_player_x? && acting_player == game.player_o
      true
    elsif game.win_by_player_o? && acting_player == game.player_x
      true
    else
      false
    end
  end
end
