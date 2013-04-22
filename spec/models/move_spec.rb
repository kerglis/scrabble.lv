require 'spec_helper'

describe Move do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @game.add_player(@user_1)
    @game.add_player(@user_2)
    @game.start
  end

  context "first moves" do
    specify { @game.moves.count.should == @game.players.count + 1 }
    specify { @game.current_move.should == @game.moves.last }
    specify { @game.current_move.should be_new }
  end

end