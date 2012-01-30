class CreateDictionaries < ActiveRecord::Migration
  def change
    create_table :dictionaries, :options => 'ENGINE MyISAM' do |t|
      t.string    :word, :limit => 20
      t.string    :locale, :limit => 2, :default => "lv"
    end
    add_index :dictionaries, :word
    add_index :dictionaries, :locale
  end
end