class Move < ActiveRecord::Base

  belongs_to    :game
  belongs_to    :player
  has_many      :game_chars

  acts_as_list   :scope => :game

  state_machine :initial => :new do
    event :finish do
      transition :to => :finished, :if => :valid_move?
    end

    after_transition :on => :finished, :do => :finish_move
  end

  def valid_move?
    true
  end

  def char_to_board(game_char, x, y)
    if cell = game.cells.free.by_pos(x, y)
      self.game_chars << game_char
      cell.add_char(game_char)
    end
  end

  def char_from_board(game_char)
    cell = game_char.cell
    cell.free
  end

  def finish_move
    game_chars.each{ |gc| gc.finalize }
  end

end