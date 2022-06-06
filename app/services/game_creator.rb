class GameCreator
  def build
    Game.new do |g|
      g.name = random_name
      g.players.build(role: "x")
      g.players.build(role: "o")
    end
  end

  def create!
    game = build.tap do |g|
      g.save!
    end

    GameOperationResult.new(game, game.player_x).success!
  end

  def random_name
    NameGenerator.new.generate
  end
end
