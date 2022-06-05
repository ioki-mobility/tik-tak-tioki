class GameCreator
  def create!
    Game.create! do |g|
      g.name = random_name
    end
  end

  def random_name
    NameGenerator.new.generate
  end
end
