$ ->

  # $(".key_watcher").each ->
  #   $this = $(this)
  #   url = $this.data("url")

  #   if url
  #     $this.on "keyup", (e) ->
  #       console.log $(this), url, $(this).val()

  $("[data-select-all]").focus ->
    @select()

  $("[data-select-all]").select()