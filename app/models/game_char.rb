# GameChar - Char, tied to Player, Move and Cell
class GameChar < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :player
  belongs_to  :move
  has_one :cell, foreign_key: :char_id

  acts_as_list column: :pos_on_hand, scope: [:game_id, :player_id]

  state_machine initial: :free do
    event :on_hand do
      transition to: :on_hand, from: [:free, :on_hand]
    end

    event :on_board do
      transition to: :on_board, from: :on_hand
    end

    event :remove_from_board do
      transition to: :on_hand, from: :on_board
    end

    event :finalize do
      transition to: :permanent, from: :on_board
    end
  end

  scope :free, -> { where(state: :free) }
  scope :on_hand, ->  { where(state: :on_hand) }
  scope :on_board, -> { where(state: :on_board) }

  def add_to_player(player, move)
    GameCharService.assign(self, player, move)
  end

  def put_on_board(x, y)
    cell = game.cells.free.by_pos(x, y)
    CellService.add_char(cell, self) if move && cell
  end
end
