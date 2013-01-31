class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id

  belongs_to :project
  belongs_to :user

  def self.for_date(date)
  	start_date = date.beginning_of_week.beginning_of_day
  	end_date = (date.end_of_week - 2).end_of_day
  	where(entry_datetime: start_date..end_date)
  end

  def self.for_date_time(date_time)
  	where(entry_datetime: date_time)
  end

  def self.for_user(user)
  	where(user_id: user.id)
  end

  def self.report_for_collection(entries)
  	(project_times = {}).tap do
	  	entries.each do |entry|
	  		project_name = entry.project.try(:name) || "Unspecified project"
	  		project_times[project_name] = (project_times[project_name] || 0.0) + (entry.duration / 2.0)
	  	end
  	end
  end

end
