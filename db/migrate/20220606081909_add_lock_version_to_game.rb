class AddLockVersionToGame < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :lock_version, :integer, null: false
  end
end
