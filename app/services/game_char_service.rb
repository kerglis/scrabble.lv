class GameCharService < Struct.new(:game_char, :player, :move)
  class << self
    def assign
      new(game_char, player, move).assign
    end
  end

  def assign
    game_char.update_attributes(
      player: player,
      move: move
    )
    game_char.on_hand
    game_char.move_to_bottom
  end
end
