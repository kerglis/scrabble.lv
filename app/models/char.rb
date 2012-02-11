class Char < ActiveRecord::Base

  def self.for_locale(locale)
    where(:locale => locale)
  end

end