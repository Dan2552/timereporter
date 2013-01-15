module ProjectsHelper

  def client_name_for_project project
    project.client.try(:name)
  end

end
