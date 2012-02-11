# encoding: UTF-8

class Game < ActiveRecord::Base

  has_many            :players
  has_many            :moves
  has_many            :cells

  before_validation   :setup_defaults
  after_create        :setup_cells

  state_machine :initial => :new do
    event :start do
      transition :to => :in_progress, :from => :new, :if => lambda { |game| game.can_start? }
    end
    event :finish do
      transition :to => :finished
    end
  end

  def self.board
    # cc - center cell
    # l2 - letter x 2
    # l3 - letter x 3
    # w2 - word x 2
    # w3 - word x 3

    out = []
    out << %w{ w3 __ __ l2 __ __ __ w3 __ __ __ l2 __ __ w3 }
    out << %w{ __ w2 __ __ __ l3 __ __ __ l3 __ __ __ w2 __ }
    out << %w{ __ __ w2 __ __ __ l2 __ l2 __ __ __ w2 __ __ }
    out << %w{ l2 __ __ w2 __ __ __ l2 __ __ __ w2 __ __ l2 }
    out << %w{ __ __ __ __ w2 __ __ __ __ __ w2 __ __ __ __ }
    out << %w{ __ l3 __ __ __ l3 __ __ __ l3 __ __ __ l3 __ }
    out << %w{ __ __ l2 __ __ __ l2 __ l2 __ __ __ l2 __ __ }
    out << %w{ w3 __ __ l2 __ __ __ cc __ __ __ l2 __ __ w3 }
    out << %w{ __ __ l2 __ __ __ l2 __ l2 __ __ __ l2 __ __ }
    out << %w{ __ l3 __ __ __ l3 __ __ __ l3 __ __ __ l3 __ }
    out << %w{ __ __ __ __ w2 __ __ __ __ __ w2 __ __ __ __ }
    out << %w{ l2 __ __ w2 __ __ __ l2 __ __ __ w2 __ __ l2 }
    out << %w{ __ __ w2 __ __ __ l2 __ l2 __ __ __ w2 __ __ }
    out << %w{ __ w2 __ __ __ l3 __ __ __ l3 __ __ __ w2 __ }
    out << %w{ w3 __ __ l2 __ __ __ w3 __ __ __ l2 __ __ w3 }
    out
  end

  def self.cell_type(str)
    (str == "__") ? "" : str
  end

  def chars
    Char.for_locale(locale)
  end

  def self.char_list(locale = nil)
    Char.for_locale(locale).map(&:char)
  end

  def char(ch)
    ch = ch.mb_chars.downcase.to_s[0]
    chars.where(:char => ch)
    {
      :char => char.ch, 
      :total => char.total, 
      :pts => char.pts, 
      :used => char_use_times(ch), 
      :left => char.total - char_use_times(ch)
    } if char
  end

  def char_use_times(ch)
    0
  end

  def min_players
    2
  end

  def max_players
    4
  end

  def cell(x, y) # x, y -- zero-based
    board[y][x] rescue nil
  end

  def can_start?
    return false unless valid?
    return false unless new?
    return true if players.count >= min_players and players.count <= max_players
    false
  end

  def add_player(user)
    if self.players.map(&:user).include?(user)
      errors.add(:game, "player with user.id = #{user.id} already added")
    elsif self.players.count >= max_players
      errors.add(:game, "too many players - max = #{max_players}")
    else
      player = Player.create(:game => self, :user => user)
      self.players << player
      player
    end
  end

  def whos_move
    players.first
  end

private

  def setup_defaults
    self.locale ||= :lv
    self.max_move_time ||= 3.minutes
  end
  
  def setup_cells
    Game.board.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        Cell.create :game => self, :x => x, :y => y, :cell_type => Game.cell_type(cell)
      end
    end
  end

end