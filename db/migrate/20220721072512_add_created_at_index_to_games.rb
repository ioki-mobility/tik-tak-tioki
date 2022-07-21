class AddCreatedAtIndexToGames < ActiveRecord::Migration[7.0]
  def change
    add_index(:games, :created_at)
  end
end
