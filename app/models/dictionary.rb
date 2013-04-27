class Dictionary

  attr_reader :dict

  delegate    :check?, :stem, :suggest, :add, :remove, :to => :dict

  def initialize(locale = nil)
    @dict = FFI::Hunspell.dict(Dictionary.language_code(locale))
  end

  def self.language_code(locale = nil)
    locale ||= I18n.locale
    "#{locale.to_s.downcase}_#{locale.to_s.upcase}"
  end

end