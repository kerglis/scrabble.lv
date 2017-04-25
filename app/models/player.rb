class Player < ActiveRecord::Base
  belongs_to  :game
  belongs_to  :user
  has_many  :moves
  has_many  :game_chars

  before_validation :copy_needed_attributes

  validates_presence_of :game, :user

  acts_as_list scope: :game

  def chars_on_hand
    game_chars.on_hand
  end

  private

  def copy_needed_attributes
    [:email, :full_name].each do |key|
      self[key] ||= user.send(key)
    end
  end
end
