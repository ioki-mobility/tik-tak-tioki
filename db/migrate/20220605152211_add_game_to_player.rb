# frozen_string_literal: true

class AddGameToPlayer < ActiveRecord::Migration[7.0]
  def change
    add_reference :players, :game, type: :uuid, index: true, foreign_key: true, null: false

    add_column :players, :role, :string, null: false

    add_column :games, :active_role, :string

    add_index :players, %i[game_id role], unique: true
  end
end
