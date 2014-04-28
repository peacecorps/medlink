$ ->
  # -- Activate jQuery placeholder ----
  $('input, textarea, text_field, phone_field, email_field').placeholder()

  # -- Activate data-link items ----
  $('.link').click -> window.location = $(@).data "link"
