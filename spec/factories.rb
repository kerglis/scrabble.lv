FactoryGirl.define do

  sequence(:title)           { |n| "Title #{n}" }
  sequence(:first_name )     { |n| "Name#{n}" }
  sequence(:last_name )      { |n| "Lastname#{n}" }
  sequence(:email  )         { |n| "email_#{n}@email.com" }
  sequence(:url  )           { |n| "http://www.url#{n}.com/" }
  sequence(:date )           { |n| Date.today - n.day }
  sequence(:manual_input)    { |n| "Input #{n}" }
  sequence(:random)          { |n| rand(100) }

end