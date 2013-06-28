class Char < ActiveRecord::Base

  scope :for_locale, lambda {|locale| where(locale: locale) }

end