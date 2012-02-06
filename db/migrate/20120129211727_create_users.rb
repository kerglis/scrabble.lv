class CreateUsers < ActiveRecord::Migration
  def up
    create_table "users", :force => true, :options => 'ENGINE MyISAM' do |t|
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

    add_index "users", ["email"], :unique => true
    add_index "users", ["reset_password_token"], :unique => true

  end

  def down
    drop_table :users
  end
end