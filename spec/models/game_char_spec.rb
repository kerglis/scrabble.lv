require 'spec_helper'

describe GameChar do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @p1 = @game.add_player(@user_1)
    @p2 = @game.add_player(@user_2)
    @game.start
  end

  context "chars-on-hand" do
    before do
      @chars_1 = @p1.chars_on_hand.map(&:id).sort
      @chars_2 = @p2.chars_on_hand.map(&:id).sort
    end

    specify { @game.current_player.should == @p1 }
    specify { @chars_1.size.should == Game.chars_per_move }
    specify { @chars_2.size.should == Game.chars_per_move }

    context "use some of chars" do
      before do
        @move = @game.current_move
        @on_hand = @move.player.chars_on_hand
        @move.char_to_board(@on_hand[0], 8,8)
        @move.char_to_board(@on_hand[1], 8,9)
        @move.char_to_board(@on_hand[2], 8,10)
        @next_move = @game.next_move
        @next_move = @game.next_move
      end

      specify { @game.current_player.should == @p1 }
      specify { @next_move.player.chars_on_hand.map(&:id).sort.should_not == @chars_1 }
      specify { (@chars_1 - @next_move.player.chars_on_hand.map(&:id).sort).size.should == 3 }
    end

  end

  context "char position" do
    specify { @p1.chars_on_hand.first.pos_on_hand.should == 1 }
    specify { @p1.chars_on_hand.last.pos_on_hand.should == Game.chars_per_move }
  end

end
