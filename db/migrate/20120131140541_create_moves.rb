class CreateMoves < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.integer   :game_id
      t.integer   :player_id
      t.integer   :position
      t.string    :state, :limit => 20
      t.timestamps
    end
  end
end