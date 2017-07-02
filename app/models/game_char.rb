# GameChar - Char, tied to Player, Move and Cell
class GameChar < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :player
  belongs_to  :move
  has_one :cell, foreign_key: :char_id

  acts_as_list column: :pos_on_hand, scope: [:game_id, :player_id]

  include AASM

  aasm(:state) do
    state :free, initial: true
    state :on_hand, :on_board, :permanent

    event :on_hand do
      transitions to: :on_hand, from: [:free, :on_hand]
    end

    event :on_board do
      transitions to: :on_board, from: :on_hand
    end

    event :remove_from_board do
      transitions to: :on_hand, from: :on_board
    end

    event :finalize do
      transitions to: :permanent, from: :on_board
    end
  end

  def add_to_player(player, move)
    GameCharService.new(self, player, move).assign
  end
end
