class Dictionary

  attr_reader :dict

  delegate    :check?, :stem, :suggest, :add, :remove, :to => :dict

  class << self
    def language_code(locale = nil)
      locale ||= I18n.locale
      "#{locale.to_s.downcase}_#{locale.to_s.upcase}"
    end

    def find_possible_words_from_chars(chars, pre_positioned = {})
      chars = chars.chars.to_a unless chars.is_a?(Array)
      2.upto(chars.length).flat_map do |l|
        chars.permutation(l).to_a.map{|x| x.join }.uniq
      end.uniq
    end
  end

  def initialize(locale = nil)
    @dict = FFI::Hunspell.dict(Dictionary.language_code(locale))
  end

  def valid_words_from_chars(chars, pre_positioned = {})
    chars = chars.chars.to_a unless chars.is_a?(Array)
    Dictionary.find_possible_words_from_chars(chars, pre_positioned).select do |word|
      check?(word)
    end
  end

end