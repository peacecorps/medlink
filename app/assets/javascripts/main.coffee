$ ->
  # Make data-link rows clickable
  $('.link').click -> window.location = $(@).data "link"

  # Show a character count below data-character-count boxes
  $('[data-character-count]').keyup ->
    $el = $ @
    remaining = $el.data('character-count') - $el.val().length
    $('.character-count').text(remaining + ' characters left')
  .keyup()

  # Automatically submit .auto-submit forms
  $('.auto-select button').hide()
  $('.auto-select select').change -> @form.submit()

  # Apply chosen boxes
  $(".chosen-select").chosen()


  # Radio button grid select helpers
  $("th.delivery-method").click ->
    method = $(@).data("method")
    $(":radio[data-method=#{method}]").prop "checked", true

  $(".clear-radios").click (e) ->
    e.preventDefault()
    $(":radio[data-method]").prop "checked", false


  # "Add another phone" extra input field
  phones_form = $(".phones-form")
  if phones_form.length > 0
    inputs = $(".phones-form .form-group")
    last = inputs[inputs.length - 1]
    template = $(last).clone()

    phones_form.on "click", ".remove", (e) ->
      e.preventDefault()
      $(@).closest(".form-group").remove()

    $(".phones-form .add").click (e) ->
      e.preventDefault()
      template.clone().insertBefore @

  roster_uploader = $("#roster_upload_form")
  roster_uploader.S3Uploader()

  roster_uploader.bind "ajax:success", (e, data) ->
    window.location = "/country/roster/edit?upload_id=" + data.upload_id