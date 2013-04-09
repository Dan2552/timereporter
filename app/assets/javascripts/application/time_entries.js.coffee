window.time_entries = ( ($) ->

  init: () ->
    @$time_slot
    @$entry
    @$resizing_top
    @$entries = $('.entry')
    @$reset_parent = false
    @original_height
    @$resize_via_ui
    @$table_cover = $("<div>", {'class': 'table-cover' })
    @add_chosen_classes()
    @set_resizeable(@$entries)
    @add_event_handlers()


  add_event_handlers: () ->
    $('.quarter-hour').on("mousedown", $.proxy(@append_time_entry, @))
    $('.day').on("mouseup", $.proxy(@save_time_entry, @))
    $('body').on('click', '.table-cover', $.proxy(@remove_form, @))

  remove_form: () ->
    @$entry = ""
    @$table_cover.remove()
    $('.form-popout').remove()

  add_chosen_classes: () ->
    $('.entry').parent().addClass('chosen')

  set_date: (date) ->
    @date = new Date("#{date}".replace(/-/g,"/"))

  append_time_entry: (evt) ->
    evt.preventDefault()
    unless $(evt.target).hasClass('remove') || evt.which != 1
      self = this
      @$time_slot = $(evt.currentTarget)
      @set_date(@$time_slot.data('datetime'))

      mousedownY = evt.pageY
      unless @$time_slot.hasClass('chosen')
        @$entry = @$time_slot.clone().toggleClass('quarter-hour entry').append( $('<div/>', {class: 'inner'}))

        @$entry.find('.inner').html('<p class="time-text"></p>')
        this_entry = @$entry
        time_text = @$entry.find('.time-text')

        @$time_slot
          .addClass('chosen')
          .html(@$entry)
          .parents('.day').mousemove (e) ->
            start = this_entry.data('datetime')
            height = this_entry.height()
            time_text.html(self.time_text(start, height))
            if e.pageY < mousedownY
              $('body').css "cursor", "ns-resize"
              self.$entry.css
                top: "auto"
                bottom: -1
              self.$entry.height(Math.ceil((mousedownY - e.pageY) / 10) * 10)
              self.$reset_parent = true
            else
              $('body').css "cursor", "ns-resize"
              self.$entry.css
                top: 0
                bottom: "auto"
              self.$entry.height(Math.ceil((e.pageY - mousedownY) / 10) * 10)
              self.$reset_parent = false

  set_new_parent: () ->
    self = this
    @$entry.parent().removeClass('chosen')
    if @$resize_via_ui
      entry_pos = @$entry.position().top
      parent_pos = @$entry.parent().position().top

      if entry_pos <= 0
        $new_parent = @$time_slot.siblings().filter ->
          return this.offsetTop == entry_pos + parent_pos
      else
        $new_parent = @$time_slot.siblings().filter ->
          return this.offsetTop == parent_pos + entry_pos

    else
      entry_top = Math.ceil((self.$entry.position().top - 1) / 10) * 10
      time_slot_top = self.$time_slot.position().top

      $new_parent = @$time_slot.siblings().filter ->
        return this.offsetTop == entry_top + time_slot_top

    $new_parent.html(@$entry.css 'top', 0).addClass('chosen')
    @$entry.data().datetime = $new_parent.data("datetime")



  save_time_entry: (evt) ->
    evt.preventDefault()
    unless $(evt.target).hasClass('remove')
      $day = $(evt.currentTarget).unbind('mousemove')
      $('body').css "cursor", "default"

      if @$entry && !@$resize_via_ui
        if @$reset_parent
          @set_new_parent()

        @$entry.data().duration = @$entry.height() / 10
        @submit_entry(@$entry.data())

  set_resizeable: ($elem) ->
    self = this
    $elem.resizable
      grid: 10
      handles: "s, n"
      start: (evt, ui) ->
        self.$entry = $(@)
        self.$resize_via_ui = true
        self.original_height = self.$entry.height()
        if $(evt.originalEvent.target).hasClass('ui-resizable-n')
          self.$resizing_top = true
        else
          self.$resizing_top = false
      resize: (evt, ui) ->
        $el = ui.element
        start = self.$entry.data('datetime')
        start_diff = $el.position().top * 1.5 * 60000
        new_start = new Date(Date.parse(start) + start_diff)
        height = $el.height()
        $el.find('.time-text').html(self.time_text(new_start, height))
      stop: (evt, ui) ->
        self.$entry = $(@)
        if self.$resizing_top
          self.set_new_parent()

        self.$entry.data().duration = self.$entry.height() / 10
        self.update_entry(self.$entry.data())
        self.$resize_via_ui = false

  submit_entry: (data) ->
    self = this
    $.ajax
      type: "POST"
      url: "/time_entries"
      data: { time_entry: { duration: data.duration, entry_datetime: data.datetime } }
      complete: () ->
        self.set_resizeable(self.$entry)
        self.$entry = false

  time_text: (start, height) ->
    format_timestamp = (timestamp)->
      new Date(timestamp).toTimeString().split(':').slice(0, 2).join(':')
    duration = height * 1.5
    start_time = format_timestamp(Date.parse(start))
    end_time = format_timestamp(Date.parse(start) + (duration * 60000))
    "<span class='from'>#{start_time}</span> - <span class='to'>#{end_time}</span> <span class='duration'>(#{height / 40}h)</span>"

  update_entry: (data) ->
    $.ajax
      type: "PUT"
      url: "/time_entries/#{data.id}"
      data: { time_entry: { duration: data.duration, entry_datetime: data.datetime } }


  show_form: ($form) ->
    $('.timetable').append( @$table_cover )
    day_left_pos = Math.round(@$entry.parents('.day').position().left)
    entry_offset = @$entry.offset()
    width = @$entry.outerWidth()
    left = Math.round(entry_offset.left)
    top = entry_offset.top


    if day_left_pos > 800
      $form.addClass('left').css
        top: top - 10
        left: (left - width) - 20
    else
      $form.addClass('right').css
        top: top - 10
        left: (left + width) - 20

    $('body').append($form.show())
    $form.find('select.chosen').chosen()
    unless $form.hasClass('edit-form')
      $('.chzn-container').trigger('mousedown')


)(jQuery)

if $('.timetable').length
  time_entries.init()