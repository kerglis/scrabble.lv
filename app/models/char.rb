class Char < ActiveRecord::Base

  def self.loc(locale)
    where(:locale => locale)
  end

end