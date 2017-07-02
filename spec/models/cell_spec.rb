require 'spec_helper'

describe Cell do
  fixtures :chars

  describe '#find_neighbor' do
    let!(:game) { create :game }
    let(:cell) { game.cells.by_pos(cell_x, cell_y) }
    let(:cell_x) { 7 }
    let(:cell_y) { 7 }

    subject { cell.find_neighbor(direction) }

    context 'north' do
      let!(:direction) { :n }
      it do
        aggregate_failures do
          expect(subject.x).to eq 7
          expect(subject.y).to eq 6
        end
      end

      context 'when on border' do
        let(:cell_y) { 0 }
        it { is_expected.to be_nil }
      end
    end

    context 'south' do
      let!(:direction) { :s }
      it do
        aggregate_failures do
          expect(subject.x).to eq 7
          expect(subject.y).to eq 8
        end
      end
      context 'when on border' do
        let(:cell_y) { 14 }
        it { is_expected.to be_nil }
      end
    end

    context 'west' do
      let!(:direction) { :w }
      it do
        aggregate_failures do
          expect(subject.x).to eq 6
          expect(subject.y).to eq 7
        end
      end
      context 'when on border' do
        let(:cell_x) { 0 }
        it { is_expected.to be_nil }
      end
    end

    context 'east' do
      let!(:direction) { :e }
      it do
        aggregate_failures do
          expect(subject.x).to eq 8
          expect(subject.y).to eq 7
        end
      end
      context 'when on border' do
        let(:cell_x) { 14 }
        it { is_expected.to be_nil }
      end
    end
  end

  context 'user move uses cells' do
    let!(:game) { create :game_initialized, players_cnt: 2 }
    let!(:move) { game.current_move }
    let!(:on_hand) { move.player.chars_on_hand }

    it do
      (0..2).each do |i|
        move.add_char_to_board(on_hand[i], 8, 8 + i)
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
