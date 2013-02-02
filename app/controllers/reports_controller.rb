class ReportsController < ApplicationController

  before_filter :date_param

  def index
    @user_reports = Report.build_list(User, @date)
    @project_reports = Report.build_list(Project, @date)
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

end
