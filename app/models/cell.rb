class Cell < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :char
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
  scope :by_pos, ->(x, y) { find_by(x: x, y: y) }

  DIRECTIONS = {
    n: 'north',
    e: 'east',
    s: 'south',
    w: 'west'
  }.freeze

  def char_set?
    game_char.present?
  end

  def find_neighbor(direction)
    send("cell_#{DIRECTIONS[direction]}")
  end

  def neighbor_ids
    @neighbor_ids ||= Hash[
      Cell.directions.map do |direction|
        [
          direction.to_sym,
          neighbor(direction).try(:id)
        ]
      end
    ]
  end

  def neighbors
    Hash[
      Cell.directions.map do |direction|
        [
          direction.to_sym,
          Cell.find_by_id(neighbor_ids[direction.to_sym])
        ]
      end
    ]
  end

  def add_char(game_char)
    CellService.add_char(self, game_char)
  end

  def remove_char
    CellService.remove_char(self, game_char)
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
