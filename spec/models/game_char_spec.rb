require 'spec_helper'

describe GameChar do
  fixtures :chars

  let(:game) { FactoryGirl.create :game_initialized, players_cnt: 2 }
  let(:p1) { game.players.first }
  let(:p2) { game.players.last }

  describe "chars-on-hand" do
    let(:chars_1) { p1.chars_on_hand.map(&:id).sort }
    let(:chars_2) { p2.chars_on_hand.map(&:id).sort }

    it do
      aggregate_failures do
        expect(game.current_player).to eq p1
        expect(chars_1.size).to eq Game.chars_per_move
        expect(chars_2.size).to eq Game.chars_per_move
      end
    end

    describe "use some of chars" do
      before do
        chars_1
        chars_2

        @move = game.current_move
        @on_hand = @move.player.chars_on_hand.order(:pos_on_hand)
        @move.add_char_to_board(@on_hand[0], 8,8)
        @move.add_char_to_board(@on_hand[1], 8,9)
        @move.add_char_to_board(@on_hand[2], 8,10)

        @move2 = game.next_move
        @on_hand2 = @move2.player.chars_on_hand.order(:pos_on_hand)
        @move2.add_char_to_board(@on_hand2[0], 7,8)
        @move2.add_char_to_board(@on_hand2[1], 9,8)
        @move2.add_char_to_board(@on_hand2[2], 10,8)

        @next_move = game.next_move
      end

      it do
        aggregate_failures do
          expect(game.current_player).to eq p1
          expect((chars_1 - @next_move.player.chars_on_hand.map(&:id)).sort.size).to eq 3
        end
      end
    end

    describe "char position" do
      let(:chars) { p1.chars_on_hand.order(:pos_on_hand) }

      it do
        aggregate_failures do
          expect(chars.first.pos_on_hand).to eq 1
          expect(chars.last.pos_on_hand).to eq Game.chars_per_move
        end
      end
    end
  end
end
