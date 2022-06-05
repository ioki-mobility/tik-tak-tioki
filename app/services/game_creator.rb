class GameCreator
  def build
    Game.new do |g|
      g.name = random_name
      player_x = g.players.build(role: "x")
      player_o = g.players.build(role: "o")
      g.active_role = ["x", "o"].sample
    end
  end

  def create!
    build.tap do |game|
      game.save!
    end
  end

  def random_name
    NameGenerator.new.generate
  end
end
