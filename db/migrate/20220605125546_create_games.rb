class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games, id: :uuid do |t|
      t.string :next_move_token, null: false
      t.string :name, null: false
      t.string :board, array: true, default: %w(f f f f f f f f f), null: false
      t.string :state, default: "awaiting_join", null: false

      t.timestamps
    end

    add_index :games, :next_move_token, unique: true
    add_index :games, :name, unique: true
    add_index :games, :state
  end
end
