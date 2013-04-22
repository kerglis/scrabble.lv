require 'spec_helper'

describe GameChar do

  pending

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @game.add_player(@user_1)
    @game.add_player(@user_2)
  end

end
