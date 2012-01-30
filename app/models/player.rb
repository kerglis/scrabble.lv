class Player < ActiveRecord::Base

  belongs_to :game
  belongs_to :user

  acts_as_list  :scope => :game

end