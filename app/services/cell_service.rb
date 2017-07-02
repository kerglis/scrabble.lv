class CellService < Struct.new(:cell, :move, :game_char)
  class << self
    def add_char(cell, move, game_char)
      new(cell, move, game_char).add_char
    end

    def remove_char(cell, game_char)
      new(cell, game_char).remove_char
    end
  end

  def add_char
    return unless cell.try(:free?)
    game_char.update_attributes(move: move)
    cell.game_char = game_char
    cell.game_char.on_board!
    cell.use!
  end

  def remove_char
    game_char.remove_from_board!
    cell.update_attribute(:char_id, nil)
  end
end
