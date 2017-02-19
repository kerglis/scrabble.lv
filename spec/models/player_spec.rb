require 'spec_helper'

describe Player do
  let!(:game) { create :game }
  let!(:user) { create :user }

  it { expect(user).to be_valid }

  describe '#add_player' do
    let(:player_1) { game.add_player(user) }

    it 'clone user props to player' do
      aggregate_failures do
        expect(player_1.full_name).to eq user.full_name
        expect(player_1.email).to eq user.email
      end
    end
  end
end
