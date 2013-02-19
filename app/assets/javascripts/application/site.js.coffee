jQuery ->
  $('body').on 'click', '.disabled', (evt) ->
    evt.preventDefault()

  $('table.tablesorter').tablesorter()
