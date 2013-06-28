# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|

    primary.item :check_word, t('navi.check_word'), check_word_dictionary_path, highlights_on: /check_word/
    primary.item :find_words, t('navi.find_words'), find_words_dictionary_path, highlights_on: /find_words/

    primary.dom_class = 'nav'
  end

end