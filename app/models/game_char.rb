class GameChar < ActiveRecord::Base

  belongs_to  :game
  belongs_to  :player
  belongs_to  :move
  has_one     :cell, :foreign_key => :char_id

  acts_as_list :column => :pos_on_hand, :scope => [:game_id, :player_id]
  default_scope :order => :pos_on_hand

  state_machine :initial => :free do
    event :to_player do
      transition :to => :on_hand, :from => [ :free, :on_hand ]
    end

    event :to_board do
      transition :to => :on_board, :from => :on_hand, :if => :find_cell?
    end

    event :from_board do
      transition :to => :on_hand, :from => :on_board, :if => :find_cell?
    end

    after_transition any => :on_hand, :do => :free_cell

    event :finalize do
      transition :to => :finished, :from => :on_board, :if => :find_cell?
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

  def find_cell
    cell || game.cells.free.where(:x => pos_x, :y => pos_y).try(:first)
  end

  def find_cell?
    find_cell.present?
  end

  def free_cell
    cell.free if cell
  end

  def put_on_board(move, x, y)
    self.pos_x = x
    self.pos_y = y
    self.move = move
    self.cell = find_cell
    self.cell.use
    self.to_board
  end

  def add_to_player(player, move)
    self.player = player
    self.move = move
    self.to_player
    # self.move_to_bottom
  end

end