require 'spec_helper'

describe Game do

  fixtures :chars

  let(:game) { FactoryGirl.create :game }
  let(:user_1) { FactoryGirl.create :user }

  it { expect(Game.min_players).to eq 2 }
  it { expect(Game.max_players).to eq 4 }

  it { expect(game.board).to be_present }

  describe "on initialization" do
    it do
      aggregate_failures do
        expect(game.locale.to_s).to eq "lv"
        expect(game.players.count).to eq 0
        expect(game).to be_new
        expect(game.max_move_time).to eq 5.minutes
        expect(game.players.empty?).to eq true
        expect(game.can_start?).to eq false
        expect(game.chars).to_not be_empty
        expect(game.moves).to be_empty
      end
    end

    context "add users" do
      before { game.add_player(user_1) }

      it do
        aggregate_failures do
          expect(game.players.count).to eq 1
          expect(game.players.first.user).to eq user_1
          expect(game.players.first.position).to eq 1
        end
      end

      context "attempt to add same user again" do
        before { game.add_player(user_1) }

        it do
          aggregate_failures do
            expect(game.errors).to be_present
            expect(game.players.count).to eq 1
          end
        end
      end

      context "add second user" do
        let(:user_2) { FactoryGirl.create :user }
        before { game.add_player(user_2) }

        it do
          aggregate_failures do
            expect(game.players.count).to eq 2
            expect(game.players.last.user).to eq user_2
            expect(game.players.last.position).to eq 2
            expect(game.can_start?).to eq true
          end
        end
      end

      context "attempt to add too many players" do
        before do
          4.times do
            game.add_player(FactoryGirl.create :user)
          end
        end

        it do
          aggregate_failures do
            expect(game.errors).to be_present
            expect(game.players.count).to eq 4
          end
        end
      end
    end

    describe "shall start when ready" do
      subject! { FactoryGirl.create :game_initialized, players_cnt: 2 }
      it { is_expected.to be_playing }
    end

    describe "game cells" do
      let(:total_cells) { Game.board_template.flatten.count }
      it { expect(game.cells.count).to eq total_cells }
    end
  end

  describe "on play" do
    let(:game) { FactoryGirl.create :game_initialized }

    it "players get their initial chars" do
      aggregate_failures do
        expect(game.moves.count).to eq game.players.count + 1
        expect(game.current_move.player).to eq game.players.first
        expect(game.current_move.player.chars_on_hand.count).to eq Game.chars_per_move
      end
    end
  end
end
