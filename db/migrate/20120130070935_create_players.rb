class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players, options: 'ENGINE MyISAM' do |t|
      t.integer     :game_id
      t.integer     :user_id
      t.integer     :position
      t.string      :email
      t.string      :full_name
      t.timestamps
    end
    add_index :players, :game_id
    add_index :players, :user_id
    add_index :players, :position
  end
end
