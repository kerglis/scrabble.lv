class CellService
  attr_accessor :cell, :move, :game_char

  def initialize(cell:, game_char:, move: nil)
    @move = move
    @game_char = game_char
    @cell = cell || game_char&.cell
  end

  def add_char
    return unless cell.try(:free?)
    game_char.update_attributes!(move: move)
    cell.game_char = game_char
    cell.game_char.on_board!
    cell.use!
  end

  def remove_char
    game_char&.remove_from_board!
    cell.update_attributes!(char_id: nil)
  end
end
