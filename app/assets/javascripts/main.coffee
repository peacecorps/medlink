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

  # -- Add user role -----
  $("#user_role").change( ->
    if $("#user_role").val() == 'pcv'
      $("#user_pcmo_id").show()
    else
      $("#user_pcmo_id").hide()
  ).change()

  # -- To pick start and end dates -----
  $("input[name='duration']").daterangepicker
    format: "YYYY-MM-DD"
    startDate: "2013-01-01"
    endDate: "2013-12-31"
  , (start, end) ->
    alert "A date range was chosen: " + start.format("YYYY-MM-DD") + " to " + end.format("YYYY-MM-DD")
