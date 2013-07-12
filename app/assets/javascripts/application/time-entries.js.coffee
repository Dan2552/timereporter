window.timeEntries = ( ($) ->

  init: () ->
    @$window = $(window)
    @$body = $('body')
    @$days = $('.day')
    @$timetable = $('.timetable')
    @tableLeft  = @$timetable.offset().left
    @longEnough = false
    $quarterHourHeight = $('.quarter-hour').outerHeight()

    @dragHeight = Math.round( $quarterHourHeight / $quarterHourHeight ) * $quarterHourHeight
    @$table_cover = $("<div>", {'class': 'table-cover' })

    @addChosenClass($('.entry').parent())
    @setResizeableUI($('.entry'))
    @addEventHandlers()


  delay: (time, fn, args...) ->
    setTimeout fn, time, args...

  # -------------------------------------------------------------------------------------- #
  addEventHandlers: () ->

    @$timetable
      .on("mousedown touchstart", '.day', $.proxy(@timeEntriesSetup, @))
      .on("mouseup", $.proxy(@saveTimeEntry, @))
      .on('mouseleave', '.entry', $.proxy(@disableHoverControls, @))
      .on('mouseenter', '.entry', $.proxy(@enableHoverControls, @))
      .on('click', '.table-cover', $.proxy(@removeForm, @))

    @$window
      .on('keydown', $.proxy(@keyDown, @))


  # -------------------------------------------------------------------------------------- #
  keyDown: (e) ->
    if e.keyCode == 27 and @mousemove
      $(@mousemove.target).parents('.day').find('.new-entry').remove()

    if e.keyCode == 68 and @hoverTrue
      @$hoverTarget.find('.remove').click()

    if e.keyCode == 69 and @hoverTrue
      @$hoverTarget.find('.edit-link').click()


  checkClickedElement: ($el) ->
    $el.hasClass('edit-link') or $el.hasClass('remove') or $el.hasClass('chosen') or $el.hasClass('inner')



  startTimer: () ->
    @timeoutID = setTimeout($.proxy(@endTimer, @), 200)

  endTimer: () ->
    @longEnough = true

  clearTimeOut: () ->
    @longEnough = false
    clearTimeout(@timeoutID)

  # -------------------------------------------------------------------------------------- #
  timeEntriesSetup: (evt) ->
    evt.preventDefault()
    unless @checkClickedElement($(evt.target)) or evt.which != 1
      @startTimer()
      @$timeSlot         = $(evt.target)
      @startDate         = @$timeSlot.data().datetime
      @$timeSlots        = $("[data-start='#{@$timeSlot.data().start}']").not('.chosen')
      @$startDay         = $(evt.currentTarget).toggleClass('active start-point')
      @startDayLeft      = @$startDay.position().left
      @$startDaySiblings = $('.day').not(@$startDay)
      @mousedownY        = evt.pageY
      @uiResize          = false

      $.when(
        @timeSlotsSetup()
      ).then(
        if @$timeSlot.find('.new-entry').length
          @$timetable.on('mousemove', $.proxy(@mouseMoving, @))
      )



  # -------------------------------------------------------------------------------------- #
  timeSlotsSetup: () ->
    @$timeSlots.each () ->
      $this = $(this)
      $template = $("<div>", {class: 'entry new-entry' }).append($('<div/>', {class: 'inner'}).append( $('<p>', {class: 'time-text'}) ))
      $this.html( $template.data('datetime', $this.data('datetime')) )



  # -------------------------------------------------------------------------------------- #
  mouseMoving: (e) ->
    @mousemove = e
    $.proxy(@calculateStartDate(), @)
    $.proxy(@updateEntryHeight(), @)
    $.proxy(@updateEntryTime(), @)
    $.proxy(@showDaySiblings(), @)



  # -------------------------------------------------------------------------------------- #
  calculateStartDate: () ->
    start = @$timeSlot.data('datetime')
    @startDiff = @$timeSlot.find('.entry').position().top * 1.5 * 60000
    @startDate = new Date(Date.parse(start) + @startDiff)



  # -------------------------------------------------------------------------------------- #
  updateEntryHeight: () ->
    @$entries = $('.day .new-entry')
    if @mousemove.pageY < @mousedownY
      @$body.css('cursor', 'n-resize')
      height = Math.ceil((@mousedownY - @mousemove.pageY) / @dragHeight) * @dragHeight
      css = { height: height, top: "auto", bottom: -1 }

    else
      @$body.css('cursor', 's-resize')
      height = Math.ceil((@mousemove.pageY - @mousedownY) / @dragHeight) * @dragHeight
      css = { height: height, top: 0, bottom: "auto" }

    @$entries.css(css)



  # -------------------------------------------------------------------------------------- #
  updateEntryTime: () ->
    self = this
    @$entries.find('.time-text').html(@SetTimeText())
    @$entries.each () ->
      $this = $(this)
      date = new Date(Date.parse($this.parent().data('datetime')) + self.startDiff)
      $this.data('datetime', date )



  # -------------------------------------------------------------------------------------- #
  showDaySiblings: () ->
    self = @

    @$startDaySiblings.each () ->
      $this = $(this)
      mouseLeft = self.mousemove.pageX - self.tableLeft
      dayLeft = $this.position().left
      dayRight = dayLeft + $this.width()

      if dayLeft < self.startDayLeft
        $this.toggleClass('active', mouseLeft < dayRight)

      else if dayRight > self.startDayLeft
        $this.toggleClass('active', mouseLeft > dayLeft)



  # -------------------------------------------------------------------------------------- #
  saveTimeEntry: (evt) ->
    evt.preventDefault()
    @$timetable.unbind('mousemove')

    unless !@$timeSlot && @checkClickedElement($(evt.target)) or @uiResize
      if @longEnough
        @$body.css('cursor', 'wait')
        self = @
        @$newEntries = $('.day.active .new-entry')

        @entryDuration = @$newEntries.height() / @dragHeight
        @clearUnwantedEntries()

        if @$newEntries.length == 1
          @submitEntry({time_entry: { duration: @entryDuration, entry_datetime: @startDate }})

        else if @$newEntries.length > 1
          allEntries = []
          @$newEntries.each () ->
            allEntries.push( { duration: self.entryDuration, entry_datetime: $(this).data('datetime') } )
          @submitEntry({ time_entries: allEntries })

        @resetTimeEntries()
      else
        @clearUnwantedEntries()
        @resetTimeEntries()


  # -------------------------------------------------------------------------------------- #
  clearUnwantedEntries: () ->
    if @$newEntries
      @addChosenClass(@$newEntries.removeClass('new-entry').parent())
    $('.day').removeClass('start-point active')
    $('.new-entry').remove()

  resetTimeEntries: () ->
    @$body.css('cursor', 'default')
    @$timeSlot         = ""
    @startDate         = ""
    @$timeSlots        = ""
    @$startDay         = ""
    @startDayLeft      = ""
    @$startDaySiblings = ""
    @mousedownY        = ""
    @clearTimeOut()



  # -------------------------------------------------------------------------------------- #
  setResizeableUI: ($entry) ->
    self = this

    $entry.resizable
      grid: self.dragHeight
      handles: "s, n"
      start: (evt, ui) ->
        self.uiResize = true
        self.$entries = ui.element
        self.entryId = self.$entries.data().id
        self.$timeSlot = ui.element.parent()
      resize: (evt, ui) ->
        $.proxy(self.calculateStartDate(), self)
        self.$entries.find('.time-text').html(self.SetTimeText())
      stop: (evt, ui) ->
        duration = self.$entries.height() / self.dragHeight
        self.updateEntry({ time_entry: { duration: duration, entry_datetime: self.startDate } })
        self.clearUnwantedEntries()



  # -------------------------------------------------------------------------------------- #
  removeForm: () ->
    @$entry = ""
    @$table_cover.remove()
    $('.form-popout').remove()



  # -------------------------------------------------------------------------------------- #
  addChosenClass: ($elem) ->
    $elem.addClass('chosen')



  # -------------------------------------------------------------------------------------- #
  disableHoverControls: (evt) ->
    @hoverTrue = false
    @$hoverTarget = ""

  enableHoverControls: (evt) ->
    @hoverTrue = true
    @$hoverTarget = $(evt.currentTarget)



  # -------------------------------------------------------------------------------------- #
  submitEntry: (data) ->
    $.ajax
      type: "POST"
      url: "/time_entries"
      data: data



  # -------------------------------------------------------------------------------------- #
  updateEntry: (data) ->
    @clearTimeOut()
    $.ajax
      type: "PUT"
      url: "/time_entries/#{@entryId}"
      data: data



  # -------------------------------------------------------------------------------------- #
  SetTimeText: () ->
    height = @$entries.height()
    duration = height * 1.5 * 60000
    formatTimestamp = (timestamp) ->
      new Date(timestamp).toTimeString().split(':').slice(0, 2).join(':')

    if @uiResize
      startTime = formatTimestamp(Date.parse(@startDate))
      endTime = formatTimestamp(Date.parse(@startDate) + duration)

    else if @mousemove.pageY < @mousedownY
      startTime = formatTimestamp(Date.parse(@startDate))
      endTime = @$timeSlot.data().end

    else
      startTime = @$timeSlot.data().start
      endTime = formatTimestamp(Date.parse(@startDate) + duration)

    "<span class='from'>#{startTime}</span> - <span class='to'>#{endTime}</span> <span class='duration'>(#{height / 40}h)</span>"



  showForm: ($form) ->
    console.log "hello"
    $('.timetable').append( @$table_cover )
    # day_left_pos = Math.round(@$entry.parents('.day').position().left)
    # entry_offset = @$entry.offset()
    # width = @$entry.outerWidth()
    # left = Math.round(entry_offset.left)
    # top = entry_offset.top


    # if day_left_pos > 800
    #   $form.addClass('left').css
    #     top: top - 10
    #     left: (left - width) - 20
    # else
    #   $form.addClass('right').css
    #     top: top - 10
    #     left: (left + width) - 20

    $form.addClass('left')
    $('body').append($form.show())
    $form.find('select.chosen').chosen()
    unless $form.hasClass('edit-form')
      $('.chzn-container').trigger('mousedown')


)(jQuery)

if $('.timetable').length
  timeEntries.init()
