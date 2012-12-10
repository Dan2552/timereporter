class TimeEntry < ActiveRecord::Base
  attr_accessible :entry_datetime, :duration, :user_id

  belongs_to :project
  belongs_to :user

  def self.accessible_by user
    TimeEntry.where(user_id: user.id)
  end

end
