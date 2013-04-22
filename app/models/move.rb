class Move < ActiveRecord::Base

  belongs_to    :game
  belongs_to    :player
  has_many      :game_chars

  acts_as_list   :scope => :game

  state_machine :initial => :new do
    event :finish do
      transition :to => :finished, :if => :valid_move?
    end

    after_transition :on => :finished, :do => :finish_move

  end

  def valid_move?
    true
  end

  def finish_move
    game_chars.each{ |gc| gc.finalize }
  end

end