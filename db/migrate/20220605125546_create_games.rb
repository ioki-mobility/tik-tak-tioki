class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :next_move_token, null: false
      t.string :name, null: false
      t.string :board, array: true, default: %w(F F F F F F F F F), null: false
      t.string :state, default: "waiting_for_other_player", null: false

      t.timestamps
    end

    add_index :games, :next_move_token, unique: true
    add_index :games, :name, unique: true
    add_index :games, :state
  end
end
