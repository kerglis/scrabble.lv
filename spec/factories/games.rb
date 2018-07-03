# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :game do
    locale :lv

    factory :game_initialized do
      transient do
        players_cnt 4
      end

      after(:create) do |game, evaluator|
        evaluator.players_cnt.times do
          game.add_player(create(:user))
        end
        game.start
      end
    end
  end
end
