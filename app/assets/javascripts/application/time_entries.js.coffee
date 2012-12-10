window.time_entries = ( ($) ->

  init: () ->
    @$timetable = $('.timetable')
    @$time_slot = $('.half_hour')
    @$chosen_timeslot = $('.chosen')
    @$entry = $('.entry')

    @add_event_handlers()
    @set_resizeable(@$entry)
    @add_chosen_class()
    # @set_sortable()


  add_chosen_class: () ->
    @$entry.parent().addClass('chosen')


  add_event_handlers: () ->
    @$time_slot.on( "click", $.proxy(@create_time_entry, @));

  # set_sortable: ($elem) ->
  #   $('.day').sortable
  #     # connectWith: ".day"
  #     # items: ".half_hour"
  #     # zIndex: 9999
  #     cursorAt: {top: 0}
  #     # start: (event, ui) ->

  set_resizeable: ($elem) ->
    $elem.resizable
      grid: 20
      handles: "s"
      containment: ".timetable"
      stop: $.proxy(@update_entry, this)

  set_duration: (evt) ->
    $elem = $(evt.target)
    duration = $elem.height() / 20
    $elem.attr("data-duration", duration)
    @update_entry($elem.data())

  submit_entry: (data) ->
    $.ajax
      type: "POST"
      url: "/time_entries"
      data: data
      success: (data) ->
        log "hello"

  create_time_entry: (evt) ->
    $elem = $(evt.currentTarget)
    unless $elem.hasClass('chosen')
      $.ajax
        type: "POST"
        url: "/time_entries"
        data: $elem.data()

  update_entry: (evt) ->
    $elem = $(evt.target)
    duration = $elem.height() / 20
    $elem.attr("data-duration", duration)

    $.ajax
      type: "PUT"
      url: "/time_entries/#{$elem.data('id')}"
      data: { duration: $elem.data('duration'), entry_datetime: $elem.data('entry-datetime') }


)(jQuery)

if $('.timetable').length
  time_entries.init()