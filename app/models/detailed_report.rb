require 'csv'

class DetailedReport

  attr_accessor :headings, :rows

  def initialize(time_entries)
    @headings = build_headings
    @rows = time_entries.map { |entry| build_column(entry) }
  end

  def build_headings
    ["Project Code", "Client", "Person", "Date start", "Date end", "Time spent"]
  end

  def build_column(entry)
    row_column = [
      entry.project.name,
      entry.project.client_name,
      entry.user.name,
      entry.start_time.localtime,
      entry.end_time.localtime,
      entry.duration_in_hours
    ]
  end

  def csv
    CSV.generate do |csv|
      csv << @headings
      @rows.each { |row| csv << row }
    end
  end
  
end
