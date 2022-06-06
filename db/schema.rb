# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_06_06_081909) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "games", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "next_move_token", null: false
    t.string "name", null: false
    t.string "board", default: ["f", "f", "f", "f", "f", "f", "f", "f", "f"], null: false, array: true
    t.string "state", default: "awaiting_join", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "active_role"
    t.integer "lock_version", null: false
    t.index ["name"], name: "index_games_on_name", unique: true
    t.index ["next_move_token"], name: "index_games_on_next_move_token", unique: true
    t.index ["state"], name: "index_games_on_state"
  end

  create_table "players", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "game_id", null: false
    t.string "role", null: false
    t.index ["game_id", "role"], name: "index_players_on_game_id_and_role", unique: true
    t.index ["game_id"], name: "index_players_on_game_id"
    t.index ["token"], name: "index_players_on_token", unique: true
  end

  add_foreign_key "players", "games"
end
