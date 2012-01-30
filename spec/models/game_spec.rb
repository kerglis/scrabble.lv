require 'spec_helper'

describe Game do
  
  describe "initialize" do
    before(:each) do
      @user_1 = User.create(:email => "one@one.lv", :first_name => "One", :last_name => "First", :password => "123456")
      @user_2 = User.create(:email => "two@two.lv", :first_name => "Two", :last_name => "Second", :password => "123456")
    end

    it "should have correct statuses upon creation" do
      @game = Game.create(:locale => :lv)

      @game.locale.should == :lv
      @game.players.count.should == 0
      @game.state.should == "new"
      @game.max_players.should == 4
      @game.max_move_time.should == 3.minutes

      @game.add_player(@user_1)
      @game.players.count.should == 1
      @game.players.first.position.should == 1
      @game.can_start?.should == false

      # try to add the same @user
      @game.add_player(@user_1)
      @game.players.count.should == 1

      @game.add_player(@user_2)
      @game.players.count.should == 2
      @game.players.last.position.should == 2

      @game.can_start?.should == true
    end
  end
end