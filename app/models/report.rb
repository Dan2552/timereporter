class Report
  attr_accessor :object, :times

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
