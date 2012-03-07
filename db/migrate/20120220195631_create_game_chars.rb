class CreateGameChars < ActiveRecord::Migration
  def change
    create_table :game_chars, :options => 'ENGINE MyISAM'  do |t|
      t.integer     :game_id
      t.integer     :player_id
      t.integer     :move_id
      t.string      :char, :limit => 1
      t.integer     :pts
      t.string      :state, :limit => 20
    end

    add_index :game_chars, :game_id
    add_index :game_chars, :player_id
    add_index :game_chars, :move_id

  end
end
