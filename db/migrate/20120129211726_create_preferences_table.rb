class CreatePreferencesTable < ActiveRecord::Migration
   def self.up
     create_table :preferences, :options => 'ENGINE MyISAM' do |t|
       t.string   :owner_type
       t.integer  :owner_id
       t.text     :data
       t.timestamps
     end
     add_index :preferences, [:owner_type, :owner_id]
  end

  def self.down
    drop_table :preferences
  end
end