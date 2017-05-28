class CreateChars < ActiveRecord::Migration
  def change
    create_table :chars, options: 'ENGINE MyISAM' do |t|
      t.string    :char, limit: 1
      t.string    :locale, limit: 2, default: 'lv'
      t.integer   :pts
      t.integer   :total
    end
    add_index :chars, [:char, :locale], unique: true

    execute '
      ALTER TABLE `chars`
      CHANGE `char` `char` VARCHAR( 1 )
      BINARY CHARACTER SET utf8
      COLLATE utf8_unicode_ci NULL DEFAULT NULL'
  end
end
