namespace :dictionary do
  
  desc "Remove long words"
  task :remove_long_words => :environment do

    words = Dictionary.where("CHAR_LENGTH(word) > 15")
    total = words.count
    
    pbar = ProgressBar.new("progress", total)
    
    words.each do |dict|
      dict.destroy if dict.word.length > 15
      pbar.inc
    end
    
    pbar.finish
  end
  
  desc "Count chars"
  task :count_chars => :environment do

    words = Dictionary.where(:locale => :lv)
    total = words.count

    pbar = ProgressBar.new("progress", total)

    chars = {}

    words.each do |dict|
      dict.word.chars.each do |ch|
        chars[ch] ||= 0
        chars[ch] += 1
      end
      pbar.inc
    end
    pbar.finish

    chars.each do |ch, cnt|
      CharCount.create :char => ch, :char_count => cnt, :locale => :lv
    end
  end

end