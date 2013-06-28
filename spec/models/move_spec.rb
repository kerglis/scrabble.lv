require 'spec_helper'

describe Move do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game_initialized, players_cnt: 2
    @p1 = @game.players.first
    @p2 = @game.players.last
  end

  context "first move" do
    specify { @game.moves.count.should == @game.players.count + 1 }
    specify { @game.current_move.should == @game.moves.last }
    specify { @game.current_player.should == @p1 }
    specify { @game.current_move.should be_new }
  end

  context "user move" do
    before do
      @move = @game.current_move
      @on_hand = @move.player.chars_on_hand.order(:pos_on_hand)
      @move.char_to_board(@on_hand[0], 8,8)
      @move.char_to_board(@on_hand[1], 8,9)
      @move.char_to_board(@on_hand[2], 8,10)
    end
  end

end