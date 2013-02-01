class ReportsController < ApplicationController

  def index
    
  end

  def user
    date_param
    user = User.find(params[:id])
    @report = Report.build(user, @date)
    render :report
  end

  def project
    date_param
    project = Project.find(params[:id])
    @report = Report.build(project, @date)
    render :report
  end

end
