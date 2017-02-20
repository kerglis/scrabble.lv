class CellService < Struct.new(:cell, :game_char)
  class << self
    def add_char
      new(cell, game_char).add_char
    end

    def remove_char
      new(cell, game_char).remove_char
    end
  end

  def add_char
    return unless cell.free?
    cell.game_char = game_char
    cell.game_char.to_board
    cell.use
  end

  def remove_char
    game_char.from_board
    cell.update_attribute(:char_id, nil)
  end
end
