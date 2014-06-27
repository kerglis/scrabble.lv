# encoding: UTF-8

u = User.where(
  first_name: "Kristaps",
  last_name: "Ērglis",
  email: "kristaps.erglis@gmail.com"
).first_or_create
u.update_attributes(admin: true)

puts u.inspect

sql = ActiveRecord::Base.connection()
sql.execute 'ALTER TABLE `chars` CHANGE `char` `char` VARCHAR( 1 ) BINARY CHARACTER SET utf8 COLLATE utf8_unicode_ci NULL DEFAULT NULL'

chars = [
  [ "a", 11, 1 ],
  [ "i", 9,  1 ],
  [ "e", 6,  1 ],
  [ "s", 8,  1 ],
  [ "n", 4,  2 ],
  [ "o", 3,  3 ],
  [ "ā", 4,  2 ],
  [ "t", 6,  1 ],
  [ "m", 4,  2 ],
  [ "j", 2,  4 ],
  [ "u", 5,  1 ],
  [ "p", 3,  2 ],
  [ "š", 1,  6 ],
  [ "r", 5,  1 ],
  [ "ē", 2,  4 ],
  [ "k", 4,  2 ],
  [ "z", 2,  3 ],
  [ "l", 3,  2 ],
  [ "d", 3,  3 ],
  [ "ī", 2,  4 ],
  [ "v", 3,  3 ],
  [ "g", 1,  5 ],
  [ "b", 1,  5 ],
  [ "c", 1,  5 ],
  [ "ū", 1,  6 ],
  [ "ļ", 1,  8 ],
  [ "ņ", 1,  6 ],
  [ "ž", 1,  8 ],
  [ "ķ", 1,  10 ],
  [ "f", 1,  10 ],
  [ "č", 1,  10 ],
  [ "ģ", 1,  10 ],
  [ "h", 1,  10 ]
]

chars.each do |char, total, pts|
  ch = Char.where(char: char, total: total,  pts: pts).first_or_create
  puts ch.inspect
end