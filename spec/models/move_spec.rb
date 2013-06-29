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

    context "get created words" do
      context "one by + shape" do
        before do
          @move = @game.next_move
          @on_hand = @move.player.chars_on_hand.order(:pos_on_hand)
          @move.char_to_board(@on_hand[0], 7,9)
          @move.char_to_board(@on_hand[1], 9,9)
          @move.char_to_board(@on_hand[2], 10,9)
          @word = @on_hand[0..2].map(&:char).join
        end

        specify { @move.find_created_words.size.should == 1 }
        specify { @move.find_created_words.first.to_s.should == @word }
      end

      context "two by L shape" do
        before do
          @move = @game.next_move
          @on_hand = @move.player.chars_on_hand.order(:pos_on_hand)
          @move.char_to_board(@on_hand[0], 8,11)
          @move.char_to_board(@on_hand[1], 9,11)
          @move.char_to_board(@on_hand[2], 10,11)
        end
        specify { @move.find_created_words.size.should == 2 }
      end

    end

  end

end