class Dictionary < ActiveRecord::Base

  def self.[](word, locale = nil)
    locale ||= I18n.locale
    if word[0] == "/" 
      op = "rlike"
      word.gsub!("/", "")
    else
      op = "="
    end
    where(:locale => locale).where("word #{op} ?", word)
  end

end