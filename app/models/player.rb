class Player < ActiveRecord::Base

  belongs_to              :game
  belongs_to              :user
  has_many                :moves
  before_create           :clone_values

  validates_presence_of   :game, :user

  acts_as_list  :scope => :game

private

  def clone_values
    [ :email, :full_name ].each { |key| self[key] = user.send(key) }
  end

end