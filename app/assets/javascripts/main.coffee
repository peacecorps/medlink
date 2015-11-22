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

  phones_form = $(".phones-form")
  if phones_form.length > 0
    inputs = $(".phones-form .form-group")
    last = inputs[inputs.length - 1]
    template = $(last).clone()

    console.log(template)

    phones_form.on "click", ".remove", (e) ->
      e.preventDefault()
      $(@).closest(".form-group").remove()

    $(".phones-form .add").click (e) ->
      e.preventDefault()
      template.clone().insertBefore @
