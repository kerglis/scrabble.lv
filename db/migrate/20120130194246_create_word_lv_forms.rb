class CreateWordLvForms < ActiveRecord::Migration
  def change
    create_table :word_lv_forms do |t|
      t.string        :word, :limit => 20
      t.string        :dict_data, :limit => 20
      t.string        :state, :limit => 20
    end
    
    add_index :word_lv_forms, :state
  end
end