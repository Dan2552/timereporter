window.dropdown = ( ($) ->

  init: () ->
    @$dropToggle = $('.dropdown-toggle')
    @$body = $('body')
    @$dropParent = @$dropToggle.parent()
    @isOpen = @$dropParent.hasClass('open')
    @addEventHandlers()


  addEventHandlers: () ->
    @$dropToggle.on("click", $.proxy(@toggleDropdown, @))
    # $('body').on("click", $.proxy(@clearMenus, @))

  clearMenus: (evt) ->
    $target = $(evt.target)
    if ( !$target.hasClass('dropdown-toggle') || !$target.hasClass('drop-link') ) && $('body').hasClass('menu-open')
      @$body.toggleClass('menu-open')
      @$dropParent.toggleClass('open')
      @isOpen = @$dropParent.hasClass('open')


  toggleDropdown: (evt) ->
    evt.preventDefault()

    @$body.toggleClass('menu-open')
    @$dropParent.toggleClass('open')
    @isOpen = @$dropParent.hasClass('open')


)(jQuery)

if $('div.dropdown').length
  window.dropdown.init()