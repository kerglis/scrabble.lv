require 'spec_helper'

describe Game do

  fixtures :chars

  describe "on initialization" do
    before(:each) do
      @game = Game.create(:locale => :lv)
      @user_1 = User.create(:email => "one@one.lv", :first_name => "One", :last_name => "First",  :password => "123456")
      @user_2 = User.create(:email => "two@two.lv", :first_name => "Two", :last_name => "Second", :password => "123456")
    end

    after(:each) do
      # HACK - rspec somehow don't clean up itself
      Cell.destroy_all
    end

    it "should have correct statuses upon creation" do
      @game.locale.should == :lv
      @game.players.count.should == 0
      @game.new?.should == true
      @game.min_players.should == 2
      @game.max_players.should == 4
      @game.max_move_time.should == 5.minutes
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
      @game.playing?.should == true
    end

    it "should have char repository" do
      @game.chars.empty?.should == false
    end

    it "should have empty moves" do
      @game.moves.empty?.should == true
    end

    it "should have cells" do
      Game.board.flatten.count.should == 15*15
      @game.cells.empty?.should == false
      @game.cells.count.should == Game.board.flatten.count
    end

  end

  describe "on play" do
    before(:all) do
      @game = Game.create(:locale => :lv)
      @user_1 = User.create(:email => "one@one.lv",     :first_name => "One",   :last_name => "First",  :password => "123456")
      @user_2 = User.create(:email => "two@two.lv",     :first_name => "Two",   :last_name => "Second", :password => "123456")
      @user_3 = User.create(:email => "three@three.lv", :first_name => "Three", :last_name => "Third",  :password => "123456")
      @user_4 = User.create(:email => "four@four.lv",   :first_name => "Four",  :last_name => "Fourth", :password => "123456")
      @game.add_player(@user_1)
      @game.add_player(@user_2)
      @game.add_player(@user_3)
      @game.add_player(@user_4)
    end

    after(:all) do
      Cell.destroy_all
      GameChar.destroy_all
    end

    it "players get their initial chars" do
      @game.start
      @game.moves.count.should == @game.players.count + 1
      @game.current_move.player.should == @game.players.first
      @game.current_move.player.chars_on_hand.count.should == @game.chars_per_move
    end

  end

end