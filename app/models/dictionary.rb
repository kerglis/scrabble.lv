class Dictionary < ActiveRecord::Base

  def self.[](word, locale = nil)
    locale ||= I18n.locale
    find_by_word_and_locale(word, locale)
  end

end