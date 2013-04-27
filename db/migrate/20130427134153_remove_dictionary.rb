class RemoveDictionary < ActiveRecord::Migration
  def change
    drop_table :dictionaries
  end
end
