class Cell < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :player
  belongs_to  :game_char, foreign_key: :char_id

  attr_accessor :neighbor_ids

  include AASM

  aasm(:state) do
    state :free, initial: :true
    state :used

    event :use do
      transitions to: :used, from: :free, guard: :char_set?
    end

    event :free, after: :remove_char do
      transitions to: :free, from: :used
    end
  end

  scope :ordered, -> { order(:y, :x) }

  def self.by_pos(x, y)
    find_by(x: x, y: y)
  end

  DIRECTIONS = {
    n: 'north',
    e: 'east',
    s: 'south',
    w: 'west'
  }.freeze

  def to_s
    game_char.char if char_set?
  end

  def char_set?
    game_char.present?
  end

  def find_neighbor(direction)
    neighbors[direction]
  end

  def neighbors
    @neighbors ||= DIRECTIONS.each_with_object({}) do |(key, direction), hash|
      hash[key] = send("cell_#{direction}")
    end
  end

  def add_char(game_char)
    CellService.new(cell: self, game_char: game_char).add_char
  end

  def remove_char
    CellService.new(cell: self, game_char: game_char).remove_char
  end

  private

  def cell_north
    game.cells.by_pos(x, y - 1)
  end

  def cell_east
    game.cells.by_pos(x + 1, y)
  end

  def cell_south
    game.cells.by_pos(x, y + 1)
  end

  def cell_west
    game.cells.by_pos(x - 1, y)
  end
end
