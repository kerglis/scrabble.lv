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
  ['ā', 4,  2],
  ['b', 1,  5],
  ['c', 1,  5],
  ['č', 1,  10],
  ['d', 3,  3],
  ['e', 6,  1],
  ['ē', 2,  4],
  ['f', 1,  10],
  ['g', 1,  5],
  ['ģ', 1,  10],
  ['h', 1,  10],
  ['i', 9,  1],
  ['ī', 2,  4],
  ['j', 2,  4],
  ['k', 4,  2],
  ['ķ', 1,  10],
  ['l', 3,  2],
  ['ļ', 1,  8],
  ['m', 4,  2],
  ['n', 4,  2],
  ['ņ', 1,  6],
  ['o', 3,  3],
  ['p', 3,  2],
  ['r', 5,  1],
  ['s', 8,  1],
  ['š', 1,  6],
  ['t', 6,  1],
  ['u', 5,  1],
  ['ū', 1,  6],
  ['v', 3,  3],
  ['z', 2,  3],
  ['ž', 1,  8],
  ['*', 2,  0], # wild card
]

# initialize for LV
locale = :lv
Char.for_locale(locale).destroy_all
chars_LV.each do |char, total, pts|
  ch = Char.create(
    locale: locale,
    char: char,
    total: total,
    pts: pts
  )
  puts ch.inspect
end
