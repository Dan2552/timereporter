window.dropdown = ( ($) ->

  init: () ->
    @$dropToggle = $('.dropdown-toggle')
    @$dropParent = @$dropToggle.parent()
    @addEventHandlers()


  addEventHandlers: () ->
    $(document)
      .on('click', $.proxy(@clearMenus, @))
      .on('click', '.dropdown-menu', (e) -> e.stopPropagation() )
      .on('click', '.dropdown-toggle', $.proxy(@toggleDropdown, @))


  clearMenus: (e) ->
    @$dropParent.each () ->
      $(this).removeClass('open')


  toggleDropdown: (e) ->
    e.preventDefault()
    e.stopPropagation()

    @$dropParent.toggleClass('open')



)(jQuery)

if $('div.dropdown').length
  window.dropdown.init()