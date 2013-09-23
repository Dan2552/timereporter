showProjectInfo = (e) ->
  e.preventDefault()
  $body = $('body')
  removeSelectedClass()
  $this = $(this).addClass('selected')
  title = $this.text()
  path = $this.attr('href')
  $projectInfo = $('.project-info')

  projectInfo = $.ajax(path, type:'GET', dataType: "JSON")
  projectInfoTemplate = $('#project-info-template').html()
  template = Handlebars.compile projectInfoTemplate

  projectInfo.done (responseText) ->
    responseText + {title: title}
    window.projectInfo = responseText
    if $projectInfo.length
      $projectInfo.replaceWith( template(responseText) )
    else
      $body.append( template(responseText) )

  setTimeout (-> $body.addClass('with-project-info')), 100


closeProjectInfo = (e) ->
  e.preventDefault()
  removeSelectedClass()
  $('body').removeClass('with-project-info')

  setTimeout (-> $('.project-info').remove()), 300


removeSelectedClass = ->
  $('li.project a').removeClass('selected')


$('body')
  .on('click', '.project-link', showProjectInfo)
  .on('click', '.project-info .close', closeProjectInfo)

