require 'spec_helper'

describe Game do
  
  describe "initialize" do
    before(:each) do
      @user_1 = User.create(:email => "one@one.lv", :first_name => "One", :last_name => "First", :password => "123456")
      @user_2 = User.create(:email => "two@two.lv", :first_name => "Two", :last_name => "Second", :password => "123456")
    end

    it "should have correct statuses upon creation" do
      @game = Game.create(:locale => :lv)

      @game.locale.should_be :lv
      @game.players.count.should_be 0
      @game.status.should_be "new"

      @game.add_player(@user_1)
      @game.players.count.should_be 1
      @game.can_start?.should_be false
      
      # try to add the same @user
      @game.add_player(@user_1)
      @game.players.count.should_be 1

      @game.add_player(@user_2)
      @game.players.count.should_be 2
      @game.can_start?.should_be true
    end
  end
end