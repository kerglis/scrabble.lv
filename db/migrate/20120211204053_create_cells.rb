class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells do |t|
      t.integer     :game_id
      t.integer     :x
      t.integer     :y
      t.integer     :char_id
      t.integer     :player_id
      t.string      :cell_type, limit: 2
      t.string      :state, limit: 10
    end

    add_index :cells, [:game_id, :x, :y], unique: true
    add_index :cells, :char_id
    add_index :cells, :player_id
    add_index :cells, :state
  end
end
