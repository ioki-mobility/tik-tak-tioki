# frozen_string_literal: true

class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :players, id: :uuid do |t|
      t.string :token, null: false

      t.timestamps
    end

    add_index :players, :token, unique: true
  end
end
