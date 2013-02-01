class Report
  attr_accessor :object, :times

  def self.build(object, date)
    entries = TimeEntry.for_date(date).for(object)
    child_type = (object.is_a? User) ? :project : :user

    (times = {}).tap do |times|
      entries.each do |entry|
        key = entry.send(child_type).try(:name) || "? Unknown #{child_type}"
        times[key] = (times[key] || 0.0) + (entry.duration / 2.0)
      end
    end

    Report.new(object, times)
  end

  def initialize(object, times)
    @object = object
    @times = times
  end

end
