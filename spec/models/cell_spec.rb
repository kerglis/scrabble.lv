require 'spec_helper'

describe Cell do
  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @p1 = @game.add_player(@user_1)
    @p2 = @game.add_player(@user_2)
    @game.start
  end

  specify { @game.cells.free.count.should == 225 }

  context "user move uses cells" do
    before do
      @move = @game.current_move
      @on_hand = @move.player.chars_on_hand

      (0..2).each do |i|
        @on_hand[i].put_on_board(@move, 8, 8+i)
      end
    end

    specify { @game.cells.free.count.should == 222 }
    specify { @game.cells.used.count.should == 3 }
    specify { @on_hand[0].should be_on_board }

    context "recall char from board" do
      before do
        @on_hand[0].from_board
      end

      specify { @game.cells.free.count.should == 223 }
      specify { @game.cells.used.count.should == 2 }

    end

  end


end
