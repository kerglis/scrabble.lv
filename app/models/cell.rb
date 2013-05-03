class Cell < ActiveRecord::Base

  belongs_to      :game
  belongs_to      :char
  belongs_to      :player
  belongs_to      :game_char, :foreign_key => :char_id

  default_scope   :order => [:y, :x]

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

  def self.by_pos(x, y)
    find_by_x_and_y(x, y)
  end

  def have_char?
    game_char.present?
  end

  def char
    return "<on_green><white> " + game_char.char.mb_chars.upcase + " </white></on_green>" if game_char
    cell_type_str
  end

  def cell_type_str
    colors = {
      :w3 => "red",
      :w2 => "magenta",
      :l3 => "blue",
      :l2 => "cyan"
    }

    color = colors[cell_type.to_sym]

    color ? "<#{color}>#{cell_type}</#{color}>" : cell_type

  end

  def add_char(game_char)
    if free?
      self.game_char = game_char
      game_char.to_board
      self.use
    end
  end

  def remove_char
    game_char.from_board
    self.update_attribute(:char_id, nil)
  end

end