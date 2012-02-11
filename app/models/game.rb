# encoding: UTF-8

class Game < ActiveRecord::Base

  has_many            :players
  has_many            :moves
  before_validation   :setup_defaults

  state_machine :initial => :new do
    event :start do
      transition :to => :in_progress, :from => :new, :if => lambda { |game| game.can_start? }
    end
    event :finish do
      transition :to => :finished
    end
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

  def scrabble

  end

private

  def setup_defaults
    self.locale ||= :lv
    self.max_move_time ||= 3.minutes
  end

end