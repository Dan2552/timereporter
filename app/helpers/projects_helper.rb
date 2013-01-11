module ProjectsHelper

  def client_name_for_project project_name
    if project_name.is_a? String
      project_name = ProjectName.find_by_value(project_name)
    end
    project_name.client
  end

end
