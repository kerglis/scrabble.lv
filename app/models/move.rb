class Move < ActiveRecord::Base

  belongs_to  :game
  belongs_to  :player
  has_many  :game_chars
  has_many  :cells, through: :game_chars

  acts_as_list scope: :game

  state_machine initial: :new do
    event :finish do
      transition to: :finished, if: :valid_move?
    end

    after_transition on: :finished, do: :finish_move
  end

  def valid_move?
    return true if game.starting?
    return false if !one_axis?
    true
  end

  def one_axis?
    cells.map(&:x).uniq.size == 1 ||
    cells.map(&:y).uniq.size == 1
  end

  def find_created_words
    words = []
    case direction_by_user
    when :one
      words << find_word_around_cell(cells.first, :ns)
      words << find_word_around_cell(cells.first, :we)
    else
      words << find_word_from_cells(direction_by_user)
      cross_dir = cross_direction(direction_by_user)
      cells.each do |cell|
        words << find_word_around_cell(cell, cross_dir)
      end
    end
    words.compact
  end

  def traverse_from_cell_to(cell, direction, include_cell = true)
    word = []
    word << cell if include_cell

    the_cell = cell
    while the_cell = the_cell.neighbor(direction)
      if the_cell.used?
        word << the_cell
      else
        break
      end
    end
    word.uniq.compact
  end

  def find_word_around_cell(cell, direction)
    word = traverse_from_cell_to(cell, left_direction(direction))
    word += traverse_from_cell_to(cell, right_direction(direction), false)
    word = word.compact.uniq

    Word.new(word) if word.size > 1
  end

  def find_word_from_cells(direction)
    cell = cells.first
    word = traverse_from_cell_to(cell, left_direction(direction))

    cells.each do |cell|
      cell.neighbor(right_direction(direction))
      word << cell if cell.used?
    end

    word = word.compact.uniq
    Word.new(word) if word.size > 1
  end

  def left_direction(direction)
    direction == :ns  ? :n : :w # N / W
  end

  def right_direction(direction)
    direction == :ns  ? :s : :e # S / E
  end

  def cross_direction(direction)
    direction == :ns ? :we : :ns
  end

  def direction_by_user
    return :one if cells.size == 1
    if one_axis?
      return :ns if cells[0].x == cells[1].x
      return :we if cells[0].y == cells[1].y
    end
  end

  def char_to_board(game_char, x, y)
    if cell = game.cells.free.by_pos(x, y)
      self.game_chars << game_char
      cell.add_char(game_char)
    end
  end

  def char_from_board(game_char)
    game_char.cell.try(:free)
  end

  def finish_move
    game_chars.each(&:finalize)
  end

end
