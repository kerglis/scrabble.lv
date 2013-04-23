class Cell < ActiveRecord::Base

  belongs_to      :game
  belongs_to      :char
  belongs_to      :player
  belongs_to      :game_char, :foreign_key => :char_id

  state_machine :initial => :free do

    event :use do
      transition :to => :used, :from => :free
    end

    event :free do
      transition :to => :free, :from => :used
    end
  end

  def self.free
    where(:state => :free)
  end

end