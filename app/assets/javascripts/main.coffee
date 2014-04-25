$ ->
  # -- Activate jQuery placeholder ----
  $('input, textarea, text_field, phone_field, email_field').placeholder()

  # -- Settings dropdown -----
  $("#dropdown-nav a").click ->
    $(".nav--dropdown").toggle()

  # -- Responsive gear menu -----
  $("ul[class=dropdown-menu]").prepend $("ul[class=nav]").html()

  $(window).resize(->
    # Move admin menu into the gear when width is less than 980
    if $(window).width() < 980
      # Display menu only in gear
      $("ul[class=dropdown-menu] li:lt(5)").css("display","inline")
      $("ul[class=nav]").css("display","none")
    else
      # Display menu, and remove it from gear
      $("ul[class=dropdown-menu] li:lt(4)").css("display","none")
      $("ul[class=nav]").css("display","block")
  ).resize()
