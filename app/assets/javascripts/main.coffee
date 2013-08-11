# FIXME: extract into a more appropriate location / framework?
$ ->
  # -- Order list -----
  $("tr[data-link]").click ->
    window.location = $(this).data "link"

  # -- Order fulfillment -----
  instructions = $ ".order__instructions textarea"
  remaining = $ ".order__characters"

  update_counts = ->
    count = 160 - instructions.val().length
    remaining.text count + " characters remaining"

  $(".order__message input").click ->
    instructions.val $(this).data "message"
    update_counts()

  instructions.keyup(update_counts).keyup()

  # -- Settings dropdown -----
  $("#dropdown-nav a").click ->
    $(".nav--dropdown").toggle()
