# frozen_string_literal: true

class GameCreator
  def build
    Game.new do |g|
      g.name = random_name
      g.players.build(role: 'x')
      g.players.build(role: 'o')
    end
  end

  def create!
    game = build.tap(&:save!)

    GameOperationResult.new(game, game.player_x).success!
  end

  def random_name
    NameGenerator.new.generate
  end
end
