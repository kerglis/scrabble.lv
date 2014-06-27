# encoding: UTF-8

u = User.where(
  first_name: "Kristaps",
  last_name: "Ērglis",
  email: "kristaps.erglis@gmail.com"
).first_or_create
u.update_attributes(admin: true)

sql = ActiveRecord::Base.connection()
sql.execute 'ALTER TABLE `chars` CHANGE `char` `char` VARCHAR( 1 ) BINARY CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL'

Char.create char: "a", total: 11,  pts: 1
Char.create char: "i", total: 9,   pts: 1
Char.create char: "e", total: 6,   pts: 1
Char.create char: "s", total: 8,   pts: 1
Char.create char: "n", total: 4,   pts: 2
Char.create char: "o", total: 3,   pts: 3
Char.create char: "ā", total: 4,   pts: 2
Char.create char: "t", total: 6,   pts: 1
Char.create char: "m", total: 4,   pts: 2
Char.create char: "j", total: 2,   pts: 4
Char.create char: "u", total: 5,   pts: 1
Char.create char: "p", total: 3,   pts: 2
Char.create char: "š", total: 1,   pts: 6
Char.create char: "r", total: 5,   pts: 1
Char.create char: "ē", total: 2,   pts: 4
Char.create char: "k", total: 4,   pts: 2
Char.create char: "z", total: 2,   pts: 3
Char.create char: "l", total: 3,   pts: 2
Char.create char: "d", total: 3,   pts: 3
Char.create char: "ī", total: 2,   pts: 4
Char.create char: "v", total: 3,   pts: 3
Char.create char: "g", total: 1,   pts: 5
Char.create char: "b", total: 1,   pts: 5
Char.create char: "c", total: 1,   pts: 5
Char.create char: "ķ", total: 1,   pts: 10
Char.create char: "ū", total: 1,   pts: 6
Char.create char: "ļ", total: 1,   pts: 8
Char.create char: "ņ", total: 1,   pts: 6
Char.create char: "ž", total: 1,   pts: 8
Char.create char: "f", total: 1,   pts: 10
Char.create char: "č", total: 1,   pts: 10
Char.create char: "ģ", total: 1,   pts: 10
Char.create char: "h", total: 1,   pts: 10
