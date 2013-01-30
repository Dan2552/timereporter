class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id

  belongs_to :project
  belongs_to :user

  def self.for_date(date)
  	start_date = date.beginning_of_week
  	end_date = date.end_of_week - 2
  	where(entry_datetime: start_date..end_date)
  end

  def self.for_date_time(date_time)
  	where(entry_datetime: date_time)
  end

  def self.for_user(user)
  	where(user_id: user.id)
  end

end
