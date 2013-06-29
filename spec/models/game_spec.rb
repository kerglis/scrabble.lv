require 'spec_helper'

describe Game do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
  end

  specify { Game.min_players.should == 2 }
  specify { Game.max_players.should == 4 }
  specify { @game.board.should be_present }

  context "on initialization" do
    specify { @game.locale.should == :lv }
    specify { @game.players.count.should == 0 }
    specify { @game.should be_new }
    specify { @game.max_move_time.should == 5.minutes }

    specify { @game.players.empty?.should == true }
    specify { @game.can_start?.should == false }
    specify { @game.chars.should_not be_empty }
    specify { @game.moves.should be_empty }

    context "add users" do
      before { @game.add_player(@user_1) }
      specify { @game.players.count.should == 1 }
      specify { @game.players.first.position.should == 1 }

      context "same user again" do
        before { @game.add_player(@user_1) }
        specify { @game.errors.should be_present }
        specify { @game.players.count.should == 1 }
      end

      context "add second user" do
        before { @game.add_player(FactoryGirl.create :user) }
        specify { @game.players.count.should == 2 }
        specify { @game.players.last.position.should == 2 }
        specify { @game.can_start?.should == true }
      end

      context "too many" do
        before do
          4.times do
            @game.add_player(FactoryGirl.create :user)
          end
        end

        specify { @game.errors.should be_present }
        specify { @game.players.count.should == 4 }

      end
    end

    context "shall start when ready" do
      before do
        @game = FactoryGirl.create :game_initialized, players_cnt: 2
      end

      specify { @game.should be_playing }
    end

    context "game cells" do
      specify { Game.board.flatten.count.should == 15*15 }
      specify { @game.cells.should_not be_empty }
      specify { @game.cells.count.should == Game.board.flatten.count }
    end
  end

  context "on play" do
    before do
      @game = FactoryGirl.create :game_initialized
    end

    context "players get their initial chars" do
      specify { @game.moves.count.should == @game.players.count + 1 }
      specify { @game.current_move.player.should == @game.players.first }
      specify { @game.current_move.player.chars_on_hand.count.should == Game.chars_per_move }
    end
  end

end