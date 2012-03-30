class GameChar < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  belongs_to :move

  state_machine :initial => :free do
    event :to_player do
      transition :to => :on_hand, :from => :free
    end

    event :to_board do
      transition :to => :on_board, :from => :on_hand, :if => :board_pos?
    end

    event :recall do
      transition :to => :on_hand, :from => :on_board
    end

    event :finalize do
      transition :to => :finished, :from => :on_board, :if => :board_pos?
    end

  end

  def self.free
    where(:state => :free)
  end

  def self.on_hand
    where(:state => :on_hand)
  end

  def self.on_board
    where(:state => :on_board)
  end

  def board_pos?
    x && y
  end

  def add_to_player(player, move)
    self.player = player
    self.move = move
    self.to_player
  end

end