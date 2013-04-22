require 'spec_helper'

describe Game do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @user_3 = FactoryGirl.create :user
    @user_4 = FactoryGirl.create :user
  end

  context "on initialization" do
    specify { @game.locale.should == :lv }
    specify { @game.players.count.should == 0 }
    specify { @game.new?.should == true }
    specify { @game.min_players.should == 2 }
    specify { @game.max_players.should == 4 }
    specify { @game.max_move_time.should == 5.minutes }

    specify { @game.players.empty?.should == true }
    specify { @game.can_start?.should == false }
    specify { @game.chars.empty?.should == false }
    specify { @game.moves.empty?.should == true }

    context "add users" do
      before { @game.add_player(@user_1) }
      specify { @game.players.count.should == 1 }
      specify { @game.players.first.position.should == 1 }

      context "add second user" do
        before { @game.add_player(@user_2) }
        specify { @game.players.count.should == 2 }
        specify { @game.players.last.position.should == 2 }
        specify { @game.can_start?.should == true }
      end
    end

    context "shall start when ready" do
      before do
        @game.add_player(@user_1)
        @game.add_player(@user_2)
        @game.start
      end
      specify { @game.playing?.should == true }
    end

    context "game cells" do
      specify { Game.board.flatten.count.should == 15*15 }
      specify { @game.cells.empty?.should == false }
      specify { @game.cells.count.should == Game.board.flatten.count }
    end
  end

  context "on play" do
    before do
      @game.add_player(@user_1)
      @game.add_player(@user_2)
      @game.add_player(@user_3)
      @game.add_player(@user_4)
    end

    context "players get their initial chars" do
      before { @game.start }
      specify { @game.moves.count.should == @game.players.count + 1 }
      specify { @game.current_move.player.should == @game.players.first }
      specify { @game.current_move.player.chars_on_hand.count.should == @game.chars_per_move }
    end

  end

end