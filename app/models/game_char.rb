class GameChar < ActiveRecord::Base

  belongs_to :game
  belongs_to :player
  belongs_to :move

  acts_as_list :column => :pos_on_hand, :scope => [:game_id, :player_id]
  default_scope :order => :pos_on_hand

  state_machine :initial => :free do
    event :to_player do
      transition :to => :on_hand, :from => [ :free, :on_hand ]
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
    pos_x && pos_y
  end

  def put_on_board(move, x, y)
    self.pos_x = x
    self.pos_y = y
    self.move = move
    self.to_board
  end

  def add_to_player(player, move)
    self.player = player
    self.move = move
    self.to_player
    # self.move_to_bottom
  end

end