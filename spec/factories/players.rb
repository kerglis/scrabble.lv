# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :player do
    game
    user
  end
end
