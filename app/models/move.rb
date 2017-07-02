class Move < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :player
  has_many  :game_chars
  has_many  :cells, through: :game_chars

  acts_as_list scope: :game

  include AASM

  aasm(:state) do
    state :new, initial: true
    state :finished

    event :finish, after: :finish_move do
      transitions to: :finished, guard: :valid_move?
    end
  end

  def valid_move?
    return true if game.starting?
    one_axis?
  end

  def one_axis?
    return true if cells.empty?
    cells.map(&:x).uniq.size == 1 ||
      cells.map(&:y).uniq.size == 1
  end

  def find_created_words
    MoveService.find_created_words(self)
  end

  def add_char_to_board(game_char, x, y)
    cell = game.cells.free.by_pos(x, y)
    CellService.add_char(cell, self, game_char)
  end

  def remove_char_from_board
    CellService.remove_char(cell)
  end

  def finish_move
    game_chars.on_board.each(&:finalize)
  end
end
