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

  class << self
    def directions
      %w(n w s e)
    end

    def by_pos(x, y)
      find_by_x_and_y(x, y)
    end
  end

  def char_set?
    game_char.present?
  end

  def find_neighbor(direction)
    pos = case direction.downcase.to_sym
          when :n # north
            [x, y - 1]
          when :s # south
            [x, y + 1]
          when :w # west
            [x - 1, y]
          when :e # east
            [x + 1, y]
          end
    game.cells.by_pos(pos[0], pos[1])
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
end
