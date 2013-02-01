module ReportsHelper

  def user_report_path user
    url_for(controller: :reports, action: :user, id: user)  
  end

  def project_report_path project
    url_for(controller: :projects, action: :user, id: project)  
  end
  
end