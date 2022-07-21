class PublicGameSerializer
  attr_accessor :game

  def initialize(game)
    self.game = game
  end

  def as_json(*)
    {
      name: game.name,
      created_at: game.created_at,
    }
  end
end
