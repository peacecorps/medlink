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
  filter_sections = (country) ->
    $(".section").each (i, section) ->
      $section = $ section

      n = 0
      $section.hide()
      $section.find("tr.order").each (j,order) ->
        $order = $ order

        if $order.hasClass "c#{country}"
          $section.show()
          n = 1 - n
          if n
            $order.addClass("striped").removeClass("unstriped")
          else
            $order.removeClass("striped").addClass("unstriped")
          $order.show()
        else
          $order.hide()

  $("#admin_country_select").change(-> filter_sections $(@).val()).change()

  if id = $("#pcmo_country_id").val()
    filter_sections id

