projects_init = () ->
  $window = $(window)
  $stickyEl = $('#letter-list')
  elTop = $stickyEl.offset().top
  $projects = $('.projects-container')

  $('.scroll-letter').on 'click', scroll_to
  $('.top-link a').on 'click', scroll_to_top

  if $window.scrollTop() > 0
    $stickyEl = $('#letter-list').addClass("sticky")

  $window.scroll () ->
    $stickyEl.toggleClass('sticky', ($window.scrollTop() + 32) > elTop)

    if $window.scrollTop() == 0
      $('.scroll-letter').removeClass('active')

    $projects.each () ->
      $this = $(this)
      position = $this.offset().top - $window.scrollTop()

      if position <= 0
          letter_class = $this.attr('id')
          $('.scroll-letter').removeClass('active')
          $("a.#{letter_class}").addClass('active')
      else
        $("a.#{letter_class}").removeClass('active')

scroll_to_top = (e) ->
  e.preventDefault()
  $('html,body').animate
    scrollTop: 0

scroll_to = (e) ->
  e.preventDefault()
  $this = $(this)
  $window = $(window)
  letter = $this.attr('href')
  $letter_div = $("#{letter}")

  if $window.scrollTop() == 0

    $('html,body').animate
      scrollTop: $letter_div.offset().top - 20
      , 'fast'

  else
    $('html,body').animate
      scrollTop: $letter_div.offset().top
      , 'fast'

jQuery ->

  if $('#letter-list').length
    projects_init()