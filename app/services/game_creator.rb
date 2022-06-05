class GameCreator
  def build
    Game.new do |game|
      game.name = random_name
      player_x = game.players.build(role: "x")
      player_o = game.players.build(role: "o")
      game.active_role = ["x", "o"].sample
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
