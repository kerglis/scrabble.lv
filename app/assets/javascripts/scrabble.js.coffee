$ ->

  $('.slider').slider()

  $("[data-select-all]").focus ->
    @select()

  $("[data-select-all]").select()

  $("a.scrabble-results").on
    click: ->
      # $($(this).data("form"))[0].reset()
      $($(this).data("form")).trigger('reset');

      $pos = $(this).data("pos") + 0
      $word = $(this).data("word")
      $len = $word.length

      for x in [1..$len]
        the_pos = x-1+$pos

        el = "#search_ch_#{the_pos}"

        # console.log el

        $(el).val($word[x-1])

