require 'csv'

class DetailedReport

  attr_accessor :headings, :rows

  def initialize(time_entries)
    @headings = ["Project Code", "Person", "Date start", "Date end", "Time spent"]
    @rows = []
    time_entries.each do |time_entry|
      row_column = []
      row_column << time_entry.project.name
      row_column << time_entry.user.name
      row_column << time_entry.start_time.localtime
      row_column << time_entry.end_time.localtime
      row_column << time_entry.duration_in_hours
      @rows << row_column
    end
  end

  def csv
    CSV.generate do |csv|
      csv << @headings
      @rows.each { |row| csv << row }
    end
  end
  
end
