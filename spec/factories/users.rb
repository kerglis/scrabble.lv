# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    email
    first_name
    last_name
    password    "123456"

    # after(:create) do |user|
    #   user.confirm!
    # end

  end
end