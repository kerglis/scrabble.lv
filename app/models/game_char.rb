class GameChar < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  belongs_to :move

  state_machine :initial => :free do
    event :to_player do
      transition :to => :on_hand, :from => :free
    end

    event :to_board do
      transition :to => :on_board, :from => :on_hand
    end
  end

  def self.free
    where(:state => :free)
  end

  def add_to_player(player, move)
    self.player = player
    self.move = move
    self.to_player
  end

end