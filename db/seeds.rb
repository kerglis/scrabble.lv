# encoding: UTF-8

u = User.where(
  first_name: 'Kristaps',
  last_name: 'Ērglis',
  email: 'kristaps.erglis@gmail.com'
).first_or_create
u.update_attributes(admin: true)

puts u.inspect

chars_LV = [
  # char, total chars, pts
  ['a', 11, 1],
  ['b', 1,  5],
  ['c', 1,  5],
  ['d', 3,  3],
  ['e', 6,  1],
  ['f', 1,  10],
  ['g', 1,  5],
  ['h', 1,  10],
  ['i', 9,  1],
  ['j', 2,  4],
  ['k', 4,  2],
  ['l', 3,  2],
  ['m', 4,  2],
  ['n', 4,  2],
  ['o', 3,  3],
  ['p', 3,  2],
  ['r', 5,  1],
  ['s', 8,  1],
  ['t', 6,  1],
  ['u', 5,  1],
  ['v', 3,  3],
  ['z', 2,  3],
  ['ā', 4,  2],
  ['č', 1,  10],
  ['ē', 2,  4],
  ['ģ', 1,  10],
  ['ī', 2,  4],
  ['ķ', 1,  10],
  ['ļ', 1,  8],
  ['ņ', 1,  6],
  ['š', 1,  6],
  ['ū', 1,  6],
  ['ž', 1,  8],
  ['*', 2,  0], # wild card
]

# initialize for LV
locale = :lv
Char.for_locale(locale).destroy_all
chars_LV.each do |char, total, pts|
  ch = Char.find_or_create_by(char: char, locale: locale)
  ch.update_attributes(
    total: total,
    pts: pts
  )
  puts ch.inspect
end
