class CreateCells < ActiveRecord::Migration
  def change
    create_table :cells, :options => 'ENGINE MyISAM' do |t|
      t.integer     :game_id
      t.integer     :x
      t.integer     :y
      t.string      :cell_type, :limit => 2
      t.string      :state, :limit => 10
    end

    add_index :cells, [:game_id, :x, :y], :unique => true
    add_index :cells, :state

  end
end