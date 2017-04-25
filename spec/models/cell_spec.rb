require 'spec_helper'

describe Cell do
  fixtures :chars

  let!(:game) { create :game_initialized, players_cnt: 2 }

  it { expect(game.cells.free.count).to eq 225 }

  context 'user move uses cells' do
    let!(:move) { game.current_move }
    let!(:on_hand) do
      binding.pry
      move.player.chars_on_hand
    end

    it do
      (0..2).each do |i|
        move.char_to_board(on_hand[i], 8, 8 + i)
      end

      aggregate_failures do
        expect(game.cells.free.count).to eq 222
        expect(game.cells.used.count).to eq 3
        expect(on_hand[0]).to be_on_board
      end
    end

    context 'recall char from board' do
      it do
        move.char_from_board(on_hand[0])
        aggregate_failures do
          expect(game.cells.free.count).to eq 223
          expect(game.cells.used.count).to eq 2
        end
      end
    end

    context 'neighbors' do
      let(:cell) { game.cells.by_pos(8, 9) }

      it do
        aggregate_failures do
          expect(cell.neighbors[:n]).to be_used
          expect(cell.neighbors[:s]).to be_used
          expect(cell.neighbors[:w]).to be_free
          expect(cell.neighbors[:e]).to be_free
        end
      end
    end
  end
end
