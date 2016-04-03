class CharCount < ActiveRecord::Base

  scope :by_locale, -> (locale) { where(locale: locale) }

end
