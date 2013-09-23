class ReportsController < ApplicationController
  before_filter :date_param

  def index
    @showFiltering ||= false
    redirect_to users_reports_url(date: params[:date])
  end

  def users
    @report_collection = Report.build_list(User.all, @date, params[:duration])
    render :index
  end

  def projects
    @showFiltering = true
    @report_collection = Report.build_list(filtered_projects, @date, params[:duration])
    render :index
  end

  def detail
    duration = Duration.new(params[:duration], @date)
    time_entries = TimeEntry.for_date(@date, duration)
    @report = DetailedReport.new(time_entries, duration, filtered_projects)
    @showFiltering = true
    respond_to do |format|
      format.html {}
      format.csv { send_data @report.csv, filename: "timereport.csv" }
    end
  end

  def user
    user = User.find(params[:id])
    @report = Report.build(user, @date, params[:duration])
    respond_to do |format|
      format.html { render :report }
      format.json { render json: @report, serializer: ReportSerializer }
    end
  end

  def project
    project = Project.find(params[:id])
    @report = Report.build(project, @date, params[:duration])
    respond_to do |format|
      format.html { render :report }
      format.json { render json: @report, serializer: ReportSerializer }
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
