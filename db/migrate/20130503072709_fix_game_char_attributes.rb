class FixGameCharAttributes < ActiveRecord::Migration
  def change
    remove_column :game_chars, :pos_x
    remove_column :game_chars, :pos_y
  end
end