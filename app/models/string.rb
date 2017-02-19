class String
  def insert_chars_at(offset, chars = {})
    new_str = dup

    chars.each do |pos, ch|
      new_pos = pos + offset.to_i
      return new_str if new_pos == -1 # don't glue to previous letter
      new_str.insert_ch!(new_pos, ch) if new_pos >= 0
    end

    new_str
  end

  def insert_chars_at!(offset, chars = {})
    new_str = dup.insert_chars_at(offset, chars)
    return nil if new_str == self
    replace(new_str)
    true
  end

  def insert_ch(pos, ch)
    return self if pos > length || pos.to_i < 0
    chars.to_a.insert(pos, ch).join
  end

  def insert_ch!(pos, ch)
    return nil if pos > length || pos.to_i < 0
    replace(insert_ch(pos, ch))
    true
  end
end
