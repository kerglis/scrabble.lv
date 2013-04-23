class Cell < ActiveRecord::Base

  belongs_to      :game
  belongs_to      :char
  belongs_to      :player
  belongs_to      :game_char, :foreign_key => :char_id

  state_machine :initial => :free do

    event :use do
      transition :to => :used, :from => :free, :if => :have_char?
    end

    event :free do
      transition :to => :free, :from => :used
    end

    after_transition :on => :free, :do => :remove_char

  end

  def self.free
    where(:state => :free)
  end

  def self.used
    where(:state => :used)
  end

  def have_char?
    game_char.present?
  end

  def remove_char
    self.update_attribute(:char_id, nil)
  end

end