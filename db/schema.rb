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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120204130338) do

  create_table "char_counts", :force => true do |t|
    t.string  "char",       :limit => 1
    t.integer "char_count"
    t.string  "locale",     :limit => 2, :default => "lv", :null => false
  end

  create_table "chars", :force => true do |t|
    t.string  "char",   :limit => 1
    t.string  "locale", :limit => 2, :default => "lv"
    t.integer "pts"
    t.integer "total"
  end

  add_index "chars", ["char", "locale"], :name => "index_chars_on_char_and_locale", :unique => true

  create_table "dictionaries", :force => true do |t|
    t.string "word",   :limit => 15
    t.string "locale", :limit => 2,  :default => "lv"
  end

  add_index "dictionaries", ["locale"], :name => "index_dictionaries_on_locale"
  add_index "dictionaries", ["word"], :name => "word"

  create_table "games", :force => true do |t|
    t.string   "locale",        :limit => 2,  :default => "lv"
    t.string   "state",         :limit => 20
    t.integer  "max_move_time"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  add_index "games", ["locale"], :name => "index_games_on_locale"
  add_index "games", ["state"], :name => "index_games_on_state"

  create_table "moves", :force => true do |t|
    t.integer  "game_id"
    t.integer  "player_id"
    t.integer  "position"
    t.string   "state",      :limit => 20
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "moves", ["game_id"], :name => "game_id"
  add_index "moves", ["player_id"], :name => "player_id"
  add_index "moves", ["position"], :name => "position"
  add_index "moves", ["state"], :name => "state"

  create_table "players", :force => true do |t|
    t.integer  "game_id"
    t.integer  "user_id"
    t.integer  "position"
    t.string   "email"
    t.string   "full_name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "players", ["game_id"], :name => "index_players_on_game_id"
  add_index "players", ["position"], :name => "index_players_on_position"
  add_index "players", ["user_id"], :name => "index_players_on_user_id"

  create_table "preferences", :force => true do |t|
    t.string   "owner_type"
    t.integer  "owner_id"
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "preferences", ["owner_type", "owner_id"], :name => "index_preferences_on_owner_type_and_owner_id"

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "",    :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                     :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.boolean  "admin",                               :default => false
    t.string   "first_name",           :limit => 30
    t.string   "last_name",            :limit => 30
    t.date     "birth_date"
    t.string   "gender",               :limit => 1
    t.text     "data_dump"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
