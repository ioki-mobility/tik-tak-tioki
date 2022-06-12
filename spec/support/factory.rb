module Factory
  extend self

  def build_game
    GameCreator.new.build
  end

  def create_game!(options = {})
    creator_result = GameCreator.new.create!
    game = creator_result.game

    if !options[:state] || options[:state] != 'awaiting_join'
      joiner_result = GameJoiner.new(game).join!
      game = joiner_result.game
    end

    if block_given?
      game.board = AsciiBoardState.decode(yield)
    end

    if options[:active_role]
      game.active_role = options[:active_role]
      game.save!
    end

    game
  end
end
