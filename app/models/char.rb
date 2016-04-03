class Char < ActiveRecord::Base

  scope :for_locale, -> (locale) { where(locale: locale) }

end
