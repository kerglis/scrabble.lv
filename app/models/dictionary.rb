class Dictionary

  attr_reader :dict

  delegate    :check?, :stem, :suggest, :add, :remove, :to => :dict

  class << self
    def language_code(locale = nil)
      locale ||= I18n.locale
      "#{locale.to_s.downcase}_#{locale.to_s.upcase}"
    end

    def find_possible_words_from_chars(chars, prepositions = {})
      chars = chars.chars.to_a unless chars.is_a?(Array)
      2.upto(chars.length).flat_map do |l|
        chars.permutation(l).to_a.flat_map{|x| apply_prepositions(x.join, prepositions) }.uniq
      end.uniq
    end

    def apply_prepositions(word, prepositions = {})
      # options for prepositions
      # :from - from offset, default - 0
      # :to - to offset, default - 0
      # :chars => {"a" => 1, "s" => 3, ... char => position (zero based) }

      if prepositions[:chars].present?
        from = prepositions[:from] || 0
        to = prepositions[:to] || 0
        (from..to).map do |offset|
          new_word = word.dup
          prepositions[:chars].each do |ch, pos|
            new_pos = pos + offset
            new_word = new_word.chars.to_a.insert(new_pos, ch).join if new_pos <= new_word.length
          end
          new_word
        end
      else
        word
      end
    end
  end

  def initialize(locale = nil)
    @dict = FFI::Hunspell.dict(Dictionary.language_code(locale))
  end

  def valid_words_from_chars(chars, prepositions = {})
    chars = chars.chars.to_a unless chars.is_a?(Array)
    Dictionary.find_possible_words_from_chars(chars, prepositions).select do |word|
      check?(word)
    end
  end

end