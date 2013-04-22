require 'spec_helper'

describe GameChar do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @game.add_player(@user_1)
    @game.add_player(@user_2)
    @game.start
  end

  context "chars-on-hand" do
    before do
      @p1 = @game.players.first
      @p2 = @game.players.last
      @chars_1 = @p1.chars_on_hand.map(&:id).sort
      @chars_2 = @p2.chars_on_hand.map(&:id).sort
    end

    specify { @game.current_player.should == @p1 }
    specify { @chars_1.size.should == @game.chars_per_move }
    specify { @chars_2.size.should == @game.chars_per_move }

    context "use some of chars" do
      before do
        @move = @game.current_move
        @on_hand = @move.player.chars_on_hand
        @on_hand[0].put_on_board(8,8)
        @on_hand[1].put_on_board(8,9)
        @on_hand[2].put_on_board(8,10)
        @next_move = @game.next_move
        @next_move = @game.next_move
      end

      specify { @game.current_player.should == @p1 }
      specify { @next_move.player.chars_on_hand.map(&:id).sort.should_not == @chars_1 }
      specify { (@chars_1 - @next_move.player.chars_on_hand.map(&:id).sort).size.should == 3 }
    end

  end

end
