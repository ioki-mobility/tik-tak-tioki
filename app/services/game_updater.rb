# frozen_string_literal: true

class GameUpdater
  # update game
  # return error or game
  attr_accessor :game, :acting_player, :params

  def initialize(game, acting_player, params = {})
    self.game = game
    self.acting_player = acting_player
    self.params = params
  end

  def update!
    result = GameOperationResult.new(game, acting_player)

    return result.error!('Game is not playing') unless game.playing?

    return result.error!("It's not the players turn") if game.active_player != acting_player

    return result.error!('No next move token provided') unless next_move_token.present?

    return result.error!('Invalid next move token') if game.next_move_token != next_move_token

    return result.error!('No valid field to mark provided') unless field.present?

    return result.error!('Field is not free') if game.board[field] != 'f'

    game.board[field] = acting_player.role

    game.state = GameStateCalculator.new(game).new_state

    update_active_role!

    # regenerate next move token anyways (also to invalidate it)
    game.regenerate_next_move_token

    game.save!

    result.success!
  end

  private

  def update_active_role!
    game.active_role = if game.playing?
                         if game.active_role == 'x'
                           'o'
                         else
                           'x'
                         end
                       end
  end

  def next_move_token
    params[:next_move_token]
  end

  def field
    Integer(params[:field], exception: false)
  end
end
