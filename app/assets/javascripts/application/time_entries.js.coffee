window.time_entries = ( ($) ->

  init: () ->
    @$timetable = $('.timetable')
    @$time_slot = $('.half_hour')
    @$chosen_timeslot = $('.chosen')
    @$entry = $('.entry')
    @$scrolling = false
    @$resize_element
    @$original_height
    @$resize_top = false
    @add_event_handlers()
    @add_chosen_classes()
    @set_resizeable(@$entry)


  add_event_handlers: () ->
    @$time_slot.on("mousedown", $.proxy(@append_time_entry, @));
    @$time_slot.not('.entry').on("mouseup", $.proxy(@save_time_entry, @));

  add_chosen_classes: () ->
    @$entry.parent().addClass('chosen')

  set_resizeable: ($elem) ->
    $elem.resizable
      grid: 20
      handles: "s, n"
      resize: (ui, evt) ->
        # log ui
      start: () ->
        $this = $(@)
        time_entries.$resize_element = $this
        time_entries.$scrolling = true
        time_entries.$original_height = $this.height()


  set_duration: (evt) ->
    $elem = $(evt.target)
    duration = $elem.height() / 20
    $elem.attr("data-duration", duration)
    @update_entry($elem.data())


  append_time_entry: (evt) ->
    $elem = $(evt.currentTarget)
    unless $elem.hasClass('chosen')
      $elem.addClass('chosen')
      $entry = $elem.removeClass('chosen').clone().toggleClass('half_hour entry').append( $('<div/>', {class: 'inner'}))
      @$resize_element = $entry
      mousedownY = evt.pageY
      position = $elem.position()
      top = position.top
      bottom = top + $elem.outerHeight()

      $elem.html( $entry )

      $elem.parents('.day').mousemove (e) ->
        time_entries.$scrolling = true
        if e.pageY < mousedownY
          $entry.css
            top: "auto"
            bottom: -1
          $entry.height(Math.ceil((mousedownY - e.pageY) / 20) * 20)
          time_entries.$resize_top = true
        else
          $entry.css
            top: 0
            bottom: "auto"
          time_entries.$resize_top = false
          $entry.height(Math.ceil((e.pageY - mousedownY) / 20) * 20)

      @submit_entry( $entry.data() )

  reset_origin: ($elem) ->
    $day_container = @$resize_element.parents('.day')
    parent_position = @$resize_element.parent().position()

    $new_parent = $day_container.find('.half_hour').filter ->
      return this.offsetTop == parent_position.top - time_entries.$resize_element.height() + 20

    @$resize_element.attr('data-datetime', $new_parent.data("datetime"))

  save_time_entry: (evt) ->
    $(".day").unbind('mousemove')
    if @$resize_top
      @reset_origin()


    if @$original_height != @$resize_element.height() && @$scrolling
      data = { duration: @$resize_element.height() / 20 , entry_datetime: @$resize_element.attr('data-datetime'), id: @$resize_element.data('id') }
      @update_entry( data )

  submit_entry: (data) ->
    $.ajax
      type: "POST"
      url: "/time_entries"
      data: { duration: data.duration, entry_datetime: data.datetime }
      success: (data) ->

  update_entry: (data) ->
    $.ajax
      type: "PUT"
      url: "/time_entries/#{data.id}"
      data: data


)(jQuery)

if $('.timetable').length
  time_entries.init()