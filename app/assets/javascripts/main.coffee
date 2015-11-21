$ ->
  # -- Activate data-link items ----
  $('.link').click -> window.location = $(@).data "link"

  $('[data-character-count]').keyup ->
    $el = $ @
    remaining = $el.data('character-count') - $el.val().length
    $('.character-count').text(remaining + ' characters left')
  .keyup()

  $('form.admin_country_select select').change ->
    @form.submit()

  $(".chosen-select").chosen()