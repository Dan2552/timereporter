class Report
  attr_accessor :object, :times

  FLATUI_COLORS = [
    "#c0392b",
    "#2ecc71",
    "#d35400",
    "#3498db",
    "#f39c12",
    "#16a085",
    "#e74c3c",
    "#27ae60",
    "#e67e22",
    "#2980b9",
    "#f1c40f",
    "#8e44ad",
    "#34495e",
    "#9b59b6",
    "#95a5a6"
  ]

  def self.build_list(object_list, date, duration=:week)
    list = object_list.map { |instance| build(instance, date, duration) }
    list.compact.where(empty?: false)
  end

  def self.build(object, date, duration=:week)
    entries = TimeEntry.for_date(date, duration).for(object)
    child_type = (object.is_a? User) ? :project : :user

    times = {}
    days = []
    entries.each do |entry|
      key = entry.send(child_type).try(:name) || "? Unknown #{child_type}"
      times[key] = (times[key] || 0.0) + (entry.duration_in_hours)
      days << entry.date unless days.include? entry.date
    end

    report = Report.new(object, times, days)
  end

  def initialize(object, times, days)
    @object = object
    @times = times
    @days = days
  end

  def days
    @days.count
  end

  def total
    total = 0
    times.each { |_,v| total += v }
    total
  end

  def empty?
    total == 0
  end

end
