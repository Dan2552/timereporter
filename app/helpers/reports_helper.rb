module ReportsHelper

  def report_path object
    action = object.class.name.downcase.to_sym
    url_for(controller: :reports, action: action, id: object)  
  end
  
end
