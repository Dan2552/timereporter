class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id

  belongs_to :project
  belongs_to :user

end
