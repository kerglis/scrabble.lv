$ ->

  $('.slider').slider()

  $("[data-select-all]").focus ->
    @select()

  $("[data-select-all]").select()

  $("a.scrabble-results").on
    click: ->
      $($(@).data("form")).trigger('reset');

      $pos = $(@).data("pos") + 0
      $word = $(@).data("word")
      $len = $word.length

      for x in [1..$len]
        the_pos = x-1+$pos

        el = "#search_ch_#{the_pos}"
        $(el).val($word[x-1])