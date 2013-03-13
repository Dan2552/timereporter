class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id, :project_id, :comment

  belongs_to :project
  belongs_to :user

  ALLOWED_DURATIONS = [:week, :month, :year]

  def self.for_date(date, duration=:week)
    duration = :week unless duration.present?
    duration = :week unless ALLOWED_DURATIONS.include? duration.to_sym
    
  	start_date = date.send("beginning_of_#{duration}").beginning_of_day
  	end_date = (date.send("end_of_#{duration}") - 2).end_of_day

  	where(entry_datetime: start_date..end_date)
  end

  def self.for(object)
    class_name = object.class.name.downcase
  	where(:"#{class_name}_id" => object.id)
  end

  #debugging only, don't call on production
  def self.randomize
    projects = 5.times.map{ |n| Project.all[n] }
    10.times do
      TimeEntry.all.each do |e|
        e.project = projects.sample
        e.user = User.all.sample
        e.save
      end
    end
  end

  def duration_in_hours
    duration / 4
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
