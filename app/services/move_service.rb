class MoveService
  attr_accessor :move, :cells, :words

  class << self
    def find_created_words(move)
      new(move).find_created_words
    end
  end

  def initialize(move)
    @move = move
    @cells = move.cells
    @words = []
  end

  def find_created_words
    case direction_by_move
    when :one
      words << find_word_around_cell(cells.first, :ns)
      words << find_word_around_cell(cells.first, :we)
    when :ns, :we
      words << find_word_from_cells(direction_by_move)
      opposite_dir = opposite_direction(direction_by_move)
      cells.each do |cell|
        words << find_word_around_cell(cell, opposite_dir)
      end
    end
    words.compact
  end

  private

  def traverse_from_cell_to(cell, direction, include_cell = true)
    word = []
    word << cell if include_cell

    the_cell = cell
    while the_cell = the_cell.find_neighbor(direction)
      break unless the_cell.used?
      word << the_cell
    end
    word.uniq.compact
  end

  def find_word_around_cell(cell, direction)
    word = traverse_from_cell_to(cell, direction_on_left(direction))
    word += traverse_from_cell_to(cell, direction_on_right(direction), false)
    word = word.compact.uniq

    Word.new(word) if word.size > 1
  end

  def find_word_from_cells(direction)
    first_cell = cells.first
    word = traverse_from_cell_to(first_cell, direction_on_left(direction))

    cells.each do |cell|
      cell.find_neighbor(direction_on_right(direction))
      word << cell if cell.used?
    end

    word = word.compact.uniq
    Word.new(word) if word.size > 1
  end

  def direction_on_left(direction)
    direction == :ns  ? :n : :w # N / W
  end

  def direction_on_right(direction)
    direction == :ns  ? :s : :e # S / E
  end

  def opposite_direction(direction)
    direction == :ns ? :we : :ns
  end

  def direction_by_move
    return :one if cells.size == 1
    return unless move.one_axis?
    return :ns if cells[0].x == cells[1].x
    return :we if cells[0].y == cells[1].y
  end
end
