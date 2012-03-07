require 'spec_helper'

describe Player do

  before(:each) do
    @game = Game.create(:locale => :lv)
    @user_1 = User.create(:email => "one@one.lv", :first_name => "One", :last_name => "First",  :password => "123456")
    @user_2 = User.create(:email => "two@two.lv", :first_name => "Two", :last_name => "Second", :password => "123456")
  end
  
  it "shall clone user >> player values" do
    @player_1 = @game.add_player(@user_1)
    @player_1.full_name.should == @user_1.full_name
    @player_1.email.should == @user_1.email
  end

end