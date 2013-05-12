class Dictionary

  attr_reader :dict

  delegate    :check?, :stem, :suggest, :add, :remove, :to => :dict

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

    def max_length(prepositions = {})
      from = prepositions[:from] || 0
      to = prepositions[:to] || 14
      to - from + 1
    end

    def find_possible_words_from_chars(chars, prepositions = {})
      chars = chars.chars.to_a unless chars.is_a?(Array)

      # trim chars to max possible limit (7)
      chars = chars[0, Game.chars_per_move]

      if prepositions[:chars].present?
        1.upto(chars.size).flat_map do |l|
          chars.permutation(l).to_a.flat_map{|x| apply_prepositions(x.join, prepositions) }.uniq
        end.uniq
      else
        2.upto(chars.size).flat_map do |l|
          chars.permutation(l).to_a.flat_map{|x| x.join}.uniq
        end.uniq
      end
    end

    def apply_prepositions(word, prepositions = {})
      # options for prepositions
      # :from - from boundry, default - 0
      # :to - to boundry, default - 14
      # :chars => {1 => "a", 3 => "s", ... position => char (zero based) }

      if prepositions[:chars].present?
        from = prepositions[:from] || 0
        to = prepositions[:to] || 14

        max_offset = [max_length(prepositions)-prepositions[:chars].size, word.length].min

        (from..to-max_offset-1).map do |offset|
          new_word = word.dup
          modified = false

          prepositions[:chars].each do |pos, ch|
            new_pos = pos - offset

            # binding.pry
            if new_pos >= 0 and new_pos <= new_word.length and prepositions[:chars][new_pos-1].blank?
              new_word = new_word.chars.to_a.insert(new_pos, ch).join
              modified = true
            end
          end
          modified ? "#{new_word}@#{offset}" : nil
          # modified ? new_word : nil
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