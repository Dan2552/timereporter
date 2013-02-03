jQuery ->
  $('body').on 'click', '.disabled', (evt) ->
    evt.preventDefault()
