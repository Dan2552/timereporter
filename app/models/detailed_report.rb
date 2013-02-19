require 'csv'

class DetailedReport

  attr_accessor :headings, :rows

  def initialize(time_entries, filtered_projects=Project.all)
    @filtered_projects = filtered_projects
    @headings = build_headings
    @rows = time_entries.map { |entry| build_column(entry) }.compact
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
        entry.start_time.localtime.strftime("%e %b %Y"),
        entry.end_time.localtime.strftime("%e %b %Y"),
        entry.duration_in_hours,
        entry.project.try(:utilised),
        entry.project.try(:billable)
      ].flatten
    end
  end

  def csv
    CSV.generate do |csv|
      csv << @headings
      @rows.each { |row| csv << row }
    end
  end

end
