class Player < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :user
  has_many  :moves
  has_many  :game_chars

  before_create :clone_values

  validates_presence_of :game, :user

  acts_as_list scope: :game

  def chars_on_hand
    game_chars.where(state: :on_hand)
  end

  private

  def clone_values
    [:email, :full_name].each do |key|
      self[key] = user.send(key)
    end
  end
end
