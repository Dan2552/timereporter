class Report
  attr_accessor :object, :times

  def self.build_list(cls, date)
    cls.all.map { |instance| build(instance, date) }.compact
  end

  def self.build(object, date)
    entries = TimeEntry.for_date(date).for(object)
    child_type = (object.is_a? User) ? :project : :user

    times = {}
    entries.each do |entry|
      key = entry.send(child_type).try(:name) || "? Unknown #{child_type}"
      times[key] = (times[key] || 0.0) + (entry.duration / 2.0)
    end

    report = Report.new(object, times)
    report = nil if report.total == 0
    report
  end

  def initialize(object, times)
    @object = object
    @times = times

  end

  def total
    total = 0
    times.each { |_,v| total += v }
    total
  end

end
