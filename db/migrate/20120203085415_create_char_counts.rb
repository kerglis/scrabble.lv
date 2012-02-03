class CreateCharCounts < ActiveRecord::Migration
  def change
    create_table :char_counts do |t|
      t.string    :char, :limit => 1
      t.integer   :char_count
      t.string    :locale, :default => "lv"
    end
  end
end