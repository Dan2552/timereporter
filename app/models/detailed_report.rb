require 'csv'

class DetailedReport

  attr_accessor :headings, :rows

  def initialize(time_entries, duration, filtered_projects=Project.all)
    @filtered_projects = filtered_projects
    @headings = build_headings
    @rows = time_entries.map { |entry| build_column(entry) }.compact
    @duration = duration
  end

  def build_headings
    ["Project Code", "Client", "Person", "Date start", "Date end", "Time spent", "Utilised", "Billable"]
  end

  def build_column(entry)
    if @filtered_projects.include? entry.project
      row_column = [
        entry.project.try(:name) || "? Unknown project",
        entry.project.try(:client_name) || "",
        entry.user.name,
        print_date(entry.start_time),
        print_date(entry.end_time),
        entry.duration_in_hours,
        entry.project.try(:utilised),
        entry.project.try(:billable)
      ].flatten
    end
  end

  def csv
    range = @duration.get_range
    start = print_date range.first
    finish = print_date range.last
    CSV.generate do |csv|
      csv << (@headings + ["", start, finish])
      @rows.each { |row| csv << row }
    end
  end

  private

  def print_date(date)
    date.localtime.strftime("%e %b %Y")
  end

end
