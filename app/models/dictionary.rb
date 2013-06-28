class Dictionary

  attr_reader :dict

  delegate    :check?, :stem, :suggest, :add, :remove, to: :dict

  class << self

    attr_accessor :the_chars

    def language_code(locale = nil)
      locale ||= I18n.locale
      "#{locale.to_s.downcase}_#{locale.to_s.upcase}"
    end

    def word_value(word, locale)
      @the_chars ||= {}
      @the_chars[locale] ||= Hash[Char.for_locale(locale).map{|ch| [ch.char, ch.pts]}]
      word.chars.map do |ch|
        @the_chars[locale][ch]
      end.sum
    end

    def find_possible_words_from_chars(chars, prepositions = {})
      chars = chars.chars.to_a unless chars.is_a?(Array)

      # trim chars to max possible limit (7)
      chars = chars[0, Game.chars_per_move]

      if prepositions[:chars].present?
        1.upto(chars.size).flat_map do |l|
          chars.permutation(l).to_a.flat_map{|x| apply_prepositions(x.join, prepositions) }
        end.compact.uniq
      else
        2.upto(chars.size).flat_map do |l|
          chars.permutation(l).to_a.flat_map{|x| x.join}
        end.compact.uniq
      end
    end

    def apply_prepositions(word, prepositions = {})
      # options for prepositions
      # :from - from boundry, default - 0
      # :to - to boundry, default - 14
      # chars: {1 => "a", 3 => "s", ... position => char (zero based) }

      if prepositions[:chars].present?
        from = prepositions[:from] || 0
        to = prepositions[:to] || 14

        from.upto(to - word.length).map do |offset|
          new_word = word.dup

          if new_word.insert_chars_at!(- offset, prepositions[:chars])
            if new_word.length + offset <= to + 1
              "#{new_word}@#{offset}"
            end
          end
        end.compact
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
      the_word, pos = word.split("@")

      check?(the_word)
    end
  end

end

class String
  def insert_chars_at(offset, chars = {})
    new_str = self.dup

    chars.each do |pos, ch|
      new_pos = pos + offset.to_i
      return new_str if new_pos == -1 # don't glue to previous letter
      new_str.insert_ch!(new_pos, ch) if new_pos >= 0
    end

    new_str
  end

  def insert_chars_at!(offset, chars = {})
    new_str = self.dup.insert_chars_at(offset, chars)
    return nil if new_str == self
    replace(new_str)
    true
  end

  def insert_ch(pos, ch)
    return self if pos > self.length or pos.to_i < 0
    self.chars.to_a.insert(pos,ch).join()
  end

  def insert_ch!(pos, ch)
    return nil if pos > self.length or pos.to_i < 0
    replace(self.insert_ch(pos, ch))
    true
  end

end