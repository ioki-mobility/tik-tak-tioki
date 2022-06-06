module Factory
  extend self

  def build_game
    GameCreator.new.build
  end

  def create_game!(options = {})
    creator_result = GameCreator.new.create!
    joiner_result = GameJoiner.new(creator_result.game).join!
    game = joiner_result.game

    if block_given?
      game.board = AsciiBoardState.decode(yield)
    end

    game.active_role = options[:active_role] if options[:active_role]

    game
  end
end
