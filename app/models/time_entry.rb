class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id, :project_id, :comment

  belongs_to :project
  belongs_to :user

  def self.for_date(date, duration=:week)
  	where(entry_datetime: Duration.new(duration).get_range(date))
  end

  def self.for(object)
    class_name = object.class.name.downcase
  	where(:"#{class_name}_id" => object.id)
  end

  def duration_in_hours
    duration / 4.0
  end

  def date
    Date.parse(entry_datetime.to_s)
  end

  def start_time
    entry_datetime
  end

  def end_time
    start_time + duration_in_hours.hours
  end

end
