require 'spec_helper'

describe Game do

  fixtures :chars

  before(:each) do
    @game = Game.create(:locale => :lv)
    @user_1 = User.create(:email => "one@one.lv", :first_name => "One", :last_name => "First", :password => "123456")
    @user_2 = User.create(:email => "two@two.lv", :first_name => "Two", :last_name => "Second", :password => "123456")
  end

  describe "on initialization" do
    it "should have correct statuses upon creation" do
      @game.locale.should == :lv
      @game.players.count.should == 0
      @game.new?.should == true
      @game.min_players.should == 2
      @game.max_players.should == 4
      @game.max_move_time.should == 3.minutes
    end

    it "shall have players to start" do
      @game.players.empty?.should == true

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

    it "shall start when ready" do
      @game.add_player(@user_1)
      @game.add_player(@user_2)
      @game.start
      @game.in_progress?.should == true
    end

    it "should have char repository" do
      @game.chars.empty?.should == false
    end

    it "should have empty moves" do
      @game.moves.empty?.should == true
    end

    it "should have cells" do
      @game.cells.empty?.should == false
      @game.cells.count.should == Game.board.flatten.count
    end

  end

  describe "gameplay" do

    before(:each) do
      @game.add_player(@user_1)
      @game.add_player(@user_2)
    end

    it "users shall have moves" do
      @game.whos_move.user.should == @user_1
    end

  end

end