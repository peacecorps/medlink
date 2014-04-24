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
    $(".order-table").show().each (i, section) ->
      $section = $ section

      visible = false
      n = 0
      $section.find("tr.order").each (j,order) ->
        $order = $ order

        if $order.hasClass "c#{country}"
          visible = true
          n = 1 - n
          if n
            $order.addClass("striped").removeClass("unstriped")
          else
            $order.removeClass("striped").addClass("unstriped")
          $order.show()
        else
          $order.hide()

      if visible
        $section.find("table").show()
        $section.find(".empty").hide()
      else
        $section.find("table").hide()
        $section.find(".empty").show()


  $("#admin_country_select").change(-> filter_sections $(@).val()).change()

  if id = $("#pcmo_country_id").val()
    filter_sections id
  else
    $(".order-table").hide()

  # -- Activate jQuery placeholder ----
  $('input, textarea').placeholder()
