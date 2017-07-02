require 'spec_helper'

describe Move do
  fixtures :chars

  let(:game) { create :game_initialized, players_cnt: 2 }
  let(:p1) { game.players.first }
  let(:p2) { game.players.last }

  context '#first move' do
    it do
      aggregate_failures do
        expect(game.moves.count).to eq game.players.count + 1
        expect(game.current_move).to eq game.moves.last
        expect(game.current_player).to eq p1
        expect(game.current_move).to be_new
      end
    end
  end

  context 'user move' do
    let(:move) { game.current_move }
    let(:on_hand) { move.player.chars_on_hand.order(:pos_on_hand) }

    # before do
    #   move.add_char_to_board(on_hand[0], 8, 8)
    #   move.add_char_to_board(on_hand[1], 8, 9)
    #   move.add_char_to_board(on_hand[2], 8, 10)
    # end

    context 'get created words' do
      context 'one by + shape' do
        let(:move) { game.next_move }
        let(:on_hand) { move.player.chars_on_hand.order(:pos_on_hand) }
        let(:word) { on_hand[0..2].map(&:char).join }

        before do
          move.add_char_to_board(on_hand[0], 7, 9)
          move.add_char_to_board(on_hand[1], 9, 9)
          move.add_char_to_board(on_hand[2], 10, 9)
        end

        it do
          aggregate_failures do
            expect(move.find_created_words.size).to eq 1
            expect(move.find_created_words.first.to_s).to eq word
          end
        end
      end

      context 'two by L shape' do
        let(:move) { game.next_move }
        let(:on_hand) { move.player.chars_on_hand.order(:pos_on_hand) }

        before do
          move.add_char_to_board(on_hand[0], 8, 11)
          move.add_char_to_board(on_hand[1], 9, 11)
          move.add_char_to_board(on_hand[2], 10, 11)
        end
        it { expect(move.find_created_words.size).to eq 2 }
      end
    end
  end
end
