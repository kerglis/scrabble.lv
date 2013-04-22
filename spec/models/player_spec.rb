require 'spec_helper'

describe Player do

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
  end

  context "shall clone user >> player values" do
    let(:player_1) { @game.add_player(@user_1) }

    specify { player_1.full_name.should == @user_1.full_name }
    specify { player_1.email.should == @user_1.email }
  end

end