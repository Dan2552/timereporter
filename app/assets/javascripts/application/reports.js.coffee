showReportInfo = (evt) ->
  evt.preventDefault()
  $('.report-list a.active').removeClass('active')
  $this = $(this).addClass('active')
  path = $this.attr('href')

  reportData = $.ajax(path, type:'GET', dataType: "JSON")
  $reportInfo = $('.info-column')
  reportTemplate = $('#report-template').html()
  template = Handlebars.compile reportTemplate

  reportData.done (responseText) ->
    chartData = []
    for key of responseText.times
      time = responseText.times[key]
      chartData.push { value: time.hours, color: time.color }

    if $reportInfo.length
      $reportInfo.replaceWith(template(responseText))
    else
      $('.report-list').after(template(responseText))

      setTimeout (->
        $(".content").addClass "with-info"
      ), 80

    setTimeout (->
      ctx = document.getElementById("reportChart").getContext("2d")
      new Chart(ctx).Pie(chartData)
    ), 400

closeReportInfo = (e) ->
  e.preventDefault()
  $('.content').removeClass('with-info')
  $reportInfo = $('.info-column')
  setTimeout (-> $reportInfo.remove()), 300

$('body')
  .on('click', '.report-link', showReportInfo)
  .on('click', '.info-column .close', closeReportInfo)
