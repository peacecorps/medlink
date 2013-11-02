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

  # -- PCMO country selector -----
  $("#admin_country_select").change( ->
    id = $(@).val()

    $("tr.order").hide()
    $("tr.order.c#{id}").show()

    # Hide sections with no content
    # TODO: this selector could be more performant
    $(".section").hide()
    $(".section:has(.c#{id})").show()
  ).change()

  # -- To pick start and end dates -----
  $("#duration").daterangepicker
    format: "MM/DD/YY"
    startDate: "9/01/13"
    endDate: "12/31/13"
  , (start, end) ->
    # FIXME: make ajax request instead of sending all of the rows
    s = start.format "YYYYMMDD"
    e = end.format   "YYYYMMDD"

    $(".order").each (n,o) ->
      $o = $ o
      date = $o.data("date")
      if s <= date && date <= e
        $o.show()
      else
        $o.hide()

  $(".datepicker").datepicker()

