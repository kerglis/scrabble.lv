# -*- coding: utf-8 -*-
SimpleNavigation::Configuration.run do |navigation|

  navigation.selected_class = 'active'
  navigation.autogenerate_item_ids = false

  navigation.items do |primary|

    primary.item :chk, t('navi.chk'), chk_path

    primary.dom_class = 'nav'
  end

end