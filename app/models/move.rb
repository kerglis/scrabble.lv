class Move < ActiveRecord::Base

  belongs_to    :game
  belongs_to    :player
  has_many      :game_chars
  has_many      :cells, through: :game_chars

  acts_as_list   scope: :game

  state_machine initial: :new do
    event :finish do
      transition to: :finished, if: :valid_move?
    end

    after_transition on: :finished, do: :finish_move
  end

  def valid_move?
    return true if game.starting?
    return false unless one_axis?
    true
  end

  def one_axis?
    cells.map(&:x).uniq.size == 1 or cells.map(&:y).uniq.size == 1
  end

  def direction_by_user
    return :any if cells.size == 1
    if one_axis?
      return :ns if cells[0].x == cells[1].x
      return :we if cells[0].y == cells[1].y
    end
  end

  def char_to_board(game_char, x, y)
    if cell = game.cells.free.by_pos(x, y).first
      self.game_chars << game_char
      cell.add_char(game_char)
    end
  end

  def char_from_board(game_char)
    game_char.cell.try(:free)
  end

  def finish_move
    game_chars.each{ |gc| gc.finalize }
  end

end