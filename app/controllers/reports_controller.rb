class ReportsController < ApplicationController

  before_filter :date_param

  def index
    redirect_to users_reports_url(date: params[:date])
  end

  def users
    @collection = Report.build_list(User.all, @date)
  end

  def projects
    @collection = Report.build_list(filtered_projects, @date)
  end

  def user
    user = User.find(params[:id])
    @report = Report.build(user, @date)
    render :report
  end

  def project
    project = Project.find(params[:id])
    @report = Report.build(project, @date)
    render :report
  end

  def detail
    time_entries = TimeEntry.for_date(@date)
    @report = DetailedReport.new(time_entries, filtered_projects)
    respond_to do |format|
      format.html {}
      format.csv { send_data @report.csv, filename: "timereport.csv" }
    end
  end

  private

  def filtered_projects
    list = Project.scoped
    Project::FILTERABLE.each do |filter|
      list = list.filter(filter) if params[filter].to_b
    end
    list
  end

end
