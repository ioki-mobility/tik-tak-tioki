class GameJoiner
  attr_accessor :game

  def initialize(game)
    self.game = game
  end

  def join!
    if !game.awaiting_join?
      result = GameOperationResult.new(game, nil)
      return result.error!("Game does not await another player to join")
    end

    game.tap do |g|
      g.state = 'playing'
      g.active_role = %w[x o].sample
      g.save!
    end

    GameOperationResult.new(game, game.player_o).success!
  end
end