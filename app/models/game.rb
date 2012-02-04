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

  CHARS = {
    :lv => {
      #ch     cnt   pts
      "a" => [ 11,  1   ],
      "i" => [ 9,   1   ],
      "e" => [ 6,   1   ],
      "s" => [ 8,   1   ],
      "n" => [ 4,   2   ],
      "o" => [ 3,   3   ],
      "ā" => [ 4,   2   ],
      "t" => [ 6,   1   ],
      "m" => [ 4,   2   ],
      "j" => [ 2,   4   ],
      "u" => [ 5,   1   ],
      "p" => [ 3,   2   ],
      "š" => [ 1,   6   ],
      "r" => [ 5,   1   ],
      "ē" => [ 2,   4   ],
      "k" => [ 4,   2   ],
      "z" => [ 2,   3   ],
      "l" => [ 3,   2   ],
      "d" => [ 3,   3   ],
      "ī" => [ 2,   4   ],
      "v" => [ 3,   3   ],
      "g" => [ 1,   5   ],
      "b" => [ 1,   5   ],
      "c" => [ 1,   5   ],
      "ķ" => [ 1,   10  ],
      "ū" => [ 1,   6   ],
      "ļ" => [ 1,   8   ],
      "ņ" => [ 1,   6   ],
      "ž" => [ 1,   8   ],
      "f" => [ 1,   10  ],
      "č" => [ 1,   10  ],
      "ģ" => [ 1,   10  ],
      "h" => [ 1,   10  ]
      # "*" => [ 2,   0   ]
    }
  }

  def self.char_list(locale)
    Game::CHARS[locale.to_sym].keys
  end

  def char(ch)
    ch = ch.mb_chars.downcase.to_s[0]
    char = Game::CHARS[locale.to_sym][ch] rescue nil
    {
      :char => ch, 
      :total => char[0], 
      :pts => char[1], 
      :used => char_use_times(ch), 
      :left => char[0] - char_use_times(ch) 
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