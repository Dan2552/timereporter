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
    $('.half_hour').on("mousedown", $.proxy(@append_time_entry, @))
    $('.day').on("mouseup", $.proxy(@save_time_entry, @))
    $('body').on('click', '.table-cover', $.proxy(@remove_form, @))

  remove_form: () ->
    @$table_cover.remove()
    $('.form-popout').remove()

  add_chosen_classes: () ->
    $('.entry').parent().addClass('chosen')

  append_time_entry: (evt) ->
    evt.preventDefault()
    unless $(evt.target).hasClass('remove') || evt.which != 1
      self = this
      @$time_slot = $(evt.currentTarget)
      mousedownY = evt.pageY
      unless @$time_slot.hasClass('chosen')
        @$entry = @$time_slot.clone().toggleClass('half_hour entry').append( $('<div/>', {class: 'inner'}))

        @$time_slot
          .addClass('chosen')
          .html(@$entry)
          .parents('.day').mousemove (e) ->
            if e.pageY < mousedownY
              $('body').css "cursor", "n-resize"
              self.$entry.css
                top: "auto"
                bottom: -1
              self.$entry.height(Math.ceil((mousedownY - e.pageY) / 20) * 20)
              self.$reset_parent = true
            else
              $('body').css "cursor", "s-resize"
              self.$entry.css
                top: 0
                bottom: "auto"
              self.$entry.height(Math.ceil((e.pageY - mousedownY) / 20) * 20)
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

        @$entry.data().duration = @$entry.height() / 20
        @submit_entry(@$entry.data())

  set_resizeable: ($elem) ->
    self = this
    $elem.resizable
      grid: 20
      handles: "s, n"
      start: (evt, ui) ->
        self.$entry = $(@)
        self.$resize_via_ui = true
        self.original_height = self.$entry.height()
        if $(evt.originalEvent.target).hasClass('ui-resizable-n')
          self.$resizing_top = true
        else
          self.$resizing_top = false
      stop: (evt, ui) ->
        self.$entry = $(@)
        if self.$resizing_top
          self.set_new_parent()

        self.$entry.data().duration = self.$entry.height() / 20
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

  update_entry: (data) ->
    $.ajax
      type: "PUT"
      url: "/time_entries/#{data.id}"
      data: { time_entry: { duration: data.duration, entry_datetime: data.datetime } }


  entry_created: ($form) ->
    $('.timetable').append( @$table_cover )
    # $('.form-popout').remove()
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
    $('.chzn-container').trigger('mousedown')


)(jQuery)

if $('.timetable').length
  time_entries.init()