require 'spec_helper'

describe Player do

  before do
    @game = FactoryGirl.create :game
    @user = FactoryGirl.create :user
  end

  specify { @user.should be_valid }

  context "clone user >> player values" do
    before { @player_1 = @game.add_player(@user) }

    specify { @player_1.full_name.should == @user.full_name }
    specify { @player_1.email.should == @user.email }
  end

end