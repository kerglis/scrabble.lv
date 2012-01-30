class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string      :locale, :limit => 2, :default => "lv"
      t.string      :state, :limit => 20
      t.timestamps
    end

    add_index :games, :locale
    add_index :games, :state

  end
end