require 'spec_helper'

describe Move do

  fixtures :chars

  before do
    @game = FactoryGirl.create :game
    @user_1 = FactoryGirl.create :user
    @user_2 = FactoryGirl.create :user
    @p1 = @game.add_player(@user_1)
    @p2 = @game.add_player(@user_2)
    @game.start
  end

  context "first move" do
    specify { @game.moves.count.should == @game.players.count + 1 }
    specify { @game.current_move.should == @game.moves.last }
    specify { @game.current_player.should == @p1 }
    specify { @game.current_move.should be_new }
  end

  context "user move" do
    before do



    end


  end

end