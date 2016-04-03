# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20130627160909) do

  create_table "cells", force: :cascade do |t|
    t.integer "game_id",   limit: 4
    t.integer "x",         limit: 4
    t.integer "y",         limit: 4
    t.integer "char_id",   limit: 4
    t.integer "player_id", limit: 4
    t.string  "cell_type", limit: 2
    t.string  "state",     limit: 10
  end

  add_index "cells", ["char_id"], name: "index_cells_on_char_id", using: :btree
  add_index "cells", ["game_id", "x", "y"], name: "index_cells_on_game_id_and_x_and_y", unique: true, using: :btree
  add_index "cells", ["player_id"], name: "index_cells_on_player_id", using: :btree
  add_index "cells", ["state"], name: "index_cells_on_state", using: :btree

  create_table "char_counts", force: :cascade do |t|
    t.string  "char",       limit: 1
    t.integer "char_count", limit: 4
    t.string  "locale",     limit: 255, default: "lv"
  end

  create_table "chars", force: :cascade do |t|
    t.string  "char",   limit: 1
    t.string  "locale", limit: 2, default: "lv"
    t.integer "pts",    limit: 4
    t.integer "total",  limit: 4
  end

  add_index "chars", ["char", "locale"], name: "index_chars_on_char_and_locale", unique: true, using: :btree

  create_table "game_chars", force: :cascade do |t|
    t.integer "game_id",     limit: 4
    t.integer "player_id",   limit: 4
    t.integer "move_id",     limit: 4
    t.string  "char",        limit: 1
    t.integer "pts",         limit: 4
    t.integer "pos_on_hand", limit: 4
    t.string  "state",       limit: 20
  end

  add_index "game_chars", ["game_id"], name: "index_game_chars_on_game_id", using: :btree
  add_index "game_chars", ["move_id"], name: "index_game_chars_on_move_id", using: :btree
  add_index "game_chars", ["player_id"], name: "index_game_chars_on_player_id", using: :btree
  add_index "game_chars", ["pos_on_hand"], name: "index_game_chars_on_pos_on_hand", using: :btree

  create_table "games", force: :cascade do |t|
    t.string   "locale",        limit: 2,  default: "lv"
    t.string   "state",         limit: 20
    t.integer  "max_move_time", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "games", ["locale"], name: "index_games_on_locale", using: :btree
  add_index "games", ["state"], name: "index_games_on_state", using: :btree

  create_table "moves", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.integer  "player_id",  limit: 4
    t.integer  "position",   limit: 4
    t.string   "state",      limit: 20
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moves", ["game_id"], name: "index_moves_on_game_id", using: :btree
  add_index "moves", ["player_id"], name: "index_moves_on_player_id", using: :btree
  add_index "moves", ["position"], name: "index_moves_on_position", using: :btree
  add_index "moves", ["state"], name: "index_moves_on_state", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer  "game_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.integer  "position",   limit: 4
    t.string   "email",      limit: 255
    t.string   "full_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["position"], name: "index_players_on_position", using: :btree
  add_index "players", ["user_id"], name: "index_players_on_user_id", using: :btree

  create_table "preferences", force: :cascade do |t|
    t.string   "owner_type", limit: 255
    t.integer  "owner_id",   limit: 4
    t.text     "data",       limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "preferences", ["owner_type", "owner_id"], name: "index_preferences_on_owner_type_and_owner_id", using: :btree

  create_table "redactor_assets", force: :cascade do |t|
    t.integer  "user_id",           limit: 4
    t.string   "data_file_name",    limit: 255, null: false
    t.string   "data_content_type", limit: 255
    t.integer  "data_file_size",    limit: 4
    t.integer  "assetable_id",      limit: 4
    t.string   "assetable_type",    limit: 30
    t.string   "type",              limit: 30
    t.integer  "width",             limit: 4
    t.integer  "height",            limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "redactor_assets", ["assetable_type", "assetable_id"], name: "idx_redactor_assetable", using: :btree
  add_index "redactor_assets", ["assetable_type", "type", "assetable_id"], name: "idx_redactor_assetable_type", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                limit: 255,   default: "",    null: false
    t.string   "encrypted_password",   limit: 128,   default: "",    null: false
    t.string   "reset_password_token", limit: 255
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",        limit: 4,     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",   limit: 255
    t.string   "last_sign_in_ip",      limit: 255
    t.integer  "failed_attempts",      limit: 4,     default: 0
    t.string   "unlock_token",         limit: 255
    t.datetime "locked_at"
    t.boolean  "admin",                              default: false
    t.string   "first_name",           limit: 30
    t.string   "last_name",            limit: 30
    t.date     "birth_date"
    t.string   "gender",               limit: 1
    t.text     "data_dump",            limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
