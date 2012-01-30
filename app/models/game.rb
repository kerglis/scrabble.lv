class Game < ActiveRecord::Base

  has_many              :players

  state_machine :initial => :new do
    after_transition do |o, t|
      mm = "do_after_#{t.to_name.to_s}".to_sym
      o.send(mm) if o.respond_to?(mm)
    end

    event :play do
      transition :to => :in_progress, :from => :new, :if => lambda { |game| game.can_start? }
    end

    event :finish do
      transition :to => :finished
    end
  end

  def max_players
    4
  end

  def can_start?
    return false unless valid?
    return true if players.count > 1 and players.count <= max_players
    false
  end

  def add_player(user)
    if self.players.map(&:user).include?(user)
      errors.add(:game, "player with user.id = #{user.id} already added")
    elsif self.players.count >= max_players
      errors.add(:game, "too many players - max = #{max_players}")
    else
      self.players << Player.create(:game => self, :user => user)
    end
  end

end