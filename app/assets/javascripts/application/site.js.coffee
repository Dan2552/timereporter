jQuery ->
  $('body').on 'click', '.disabled', (evt) ->
    evt.preventDefault()

  $notice = $("#flash-notice")
  $notice.delay(3000).fadeOut () ->
    $notice.remove()

