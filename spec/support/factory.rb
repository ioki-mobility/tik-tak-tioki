# frozen_string_literal: true

module Factory
  module_function

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

    game.board = AsciiBoardState.decode(yield) if block_given?

    if options[:active_role]
      game.active_role = options[:active_role]
      game.save!
    end

    game
  end
end
