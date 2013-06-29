require 'spec_helper'

describe Cell do
  fixtures :chars

  before do
    @game = FactoryGirl.create :game_initialized, players_cnt: 2
  end

  specify { @game.cells.free.count.should == 225 }

  context "user move uses cells" do
    before do
      @move = @game.current_move
      @on_hand = @move.player.chars_on_hand

      (0..2).each do |i|
        @move.char_to_board(@on_hand[i], 8, 8+i)
      end
    end

    specify { @game.cells.free.count.should == 222 }
    specify { @game.cells.used.count.should == 3 }
    specify { @on_hand[0].should be_on_board }

    context "recall char from board" do
      before do
        @move.char_from_board(@on_hand[0])
      end

      specify { @game.cells.free.count.should == 223 }
      specify { @game.cells.used.count.should == 2 }
    end

    context "neighbors" do
      before do
        @cell = @game.cells.by_pos(8, 9)
      end

      specify { @cell.neighbors[:n].should be_used }
      specify { @cell.neighbors[:s].should be_used }
      specify { @cell.neighbors[:w].should be_free }
      specify { @cell.neighbors[:e].should be_free }
    end

  end


end
