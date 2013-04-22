class Game < ActiveRecord::Base

  has_many            :players,     :dependent => :destroy
  has_many            :moves,       :dependent => :destroy
  has_many            :cells,       :dependent => :destroy
  has_many            :game_chars,  :dependent => :destroy

  before_validation   :setup_defaults
  after_create        :setup_cells
  after_create        :setup_chars

  state_machine :initial => :new do
    event :start do
      transition :to => :playing, :from => :new, :if => lambda { |game| game.can_start? }
    end

    after_transition :on => :start, :do => :first_move

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

  def chars_per_move
    7
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

  def current_move
    moves.last
  end

  def current_player
    current_move.player
  end

  def get_random_chars(player, move)
    add_count = chars_per_move - player.chars_on_hand.count
    add_count.times do
      char = game_chars.free.order("rand()").first
      char.add_to_player(player, move)
    end
  end

  def next_player
    return players.first unless current_move
    next_player_position = current_move.player.position + 1
    next_player_position = 1 if next_player_position > players.count
    players.find_by_position(next_player_position)
  end

  def next_move
    if current_move and !current_move.finished?
      return unless current_move.finish
    end

    player = next_player
    create_move_for_player(player)
  end

  def create_move_for_player(player)
    if player
      move = Move.create :game => self, :player => player
      get_random_chars(player, move)
      move
    end
  end

private

  def setup_defaults
    self.locale ||= :lv
    self.max_move_time ||= 5.minutes
  end

  def setup_cells
    Game.board.each_with_index do |line, y|
      line.each_with_index do |cell, x|
        Cell.create :game => self, :x => x, :y => y, :cell_type => Game.cell_type(cell)
      end
    end
  end

  def setup_chars
    the_chars = Char.for_locale(locale)

    the_chars.each do |char|
      char.total.times do
        GameChar.create :game => self, :char => char.char, :pts => char.pts
      end
    end
  end

  def first_move
    # each player gets their chars
    players.each do |player|
      move = create_move_for_player(player)
      move.finish
    end
    next_move
  end

end