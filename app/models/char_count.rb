class CharCount < ActiveRecord::Base

  scope :by_locale, lambda { |locale| where(locale: locale) }


end