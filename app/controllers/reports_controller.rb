class ReportsController < ApplicationController

  before_filter :date_param

  def index
    @user_reports = Report.build_list(User.all, @date)
    @project_reports = Report.build_list(filtered_projects, @date)

    if params[:collection] == "users"
      @collection = @user_reports
    elsif params[:collection] == "projects"
      @collection = @project_reports
    end

    @collection ||= @user_reports

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
    @report = DetailedReport.new(time_entries)
    respond_to do |format|
      format.html {}
      format.csv { send_data @report.csv, filename: 'timereport.csv' }
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
