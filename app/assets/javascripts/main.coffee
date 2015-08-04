$ ->
  # -- Activate jQuery placeholder ----
  $('input, textarea, text_field, phone_field, email_field').placeholder()

  # -- Activate data-link items ----
  $('.link').click -> window.location = $(@).data "link"

  $('[data-character-count]').keyup ->
    $el = $ @
    remaining = $el.data('character-count') - $el.val().length
    $('.character-count').text(remaining + ' characters left')
  .keyup()

