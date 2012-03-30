require 'spec_helper'

describe GameChar do

  before(:all) do
    @game = Game.create(:locale => :lv)
    @user_1 = User.create(:email => "one@one.lv",     :first_name => "One",   :last_name => "First",  :password => "123456")
    @user_2 = User.create(:email => "two@two.lv",     :first_name => "Two",   :last_name => "Second", :password => "123456")
    @game.add_player(@user_1)
    @game.add_player(@user_2)
  end
  
  it "should have" do
    free_cnt = @game.game_chars.free.count
    
    
    
    
    
    
  end



  
  
end
