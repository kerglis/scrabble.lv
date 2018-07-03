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
    let!(:move) { game.current_move }
    let!(:on_hand) { move.player.chars_on_hand.order(:pos_on_hand) }

    before do
      move.add_char_to_board(on_hand[0], 8, 8)
      move.add_char_to_board(on_hand[1], 8, 9)
      move.add_char_to_board(on_hand[2], 8, 10)
    end

    context 'get created words' do
      context 'one by + shape' do
        let(:move2) { game.next_move }
        let(:on_hand2) { move2.player.chars_on_hand.order(:pos_on_hand) }
        let(:expected_word) do
          word = on_hand2[0..2].map(&:char).join
          # insert char in 2nd pos from crossing word
          word.insert(1, on_hand[1].char)
          word
        end

        before do
          move2.add_char_to_board(on_hand2[0], 7, 9)
          move2.add_char_to_board(on_hand2[1], 9, 9)
          move2.add_char_to_board(on_hand2[2], 10, 9)
        end

        it do
          aggregate_failures do
            expect(move2.find_created_words.size).to eq 1
            expect(move2.find_created_words.first.to_s).to eq expected_word
          end
        end
      end

      context 'two by L shape' do
        let(:move2) { game.next_move }
        let(:on_hand2) { move2.player.chars_on_hand.order(:pos_on_hand) }

        before do
          move2.add_char_to_board(on_hand2[0], 8, 11)
          move2.add_char_to_board(on_hand2[1], 9, 11)
          move2.add_char_to_board(on_hand2[2], 10, 11)
        end

        it { expect(move2.find_created_words.size).to eq 2 }
      end
    end
  end
end
