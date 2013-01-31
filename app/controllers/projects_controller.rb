class ProjectsController < ApplicationController

  def index
    @projects = Project.ordered_by_name.group_by{|u| u.name[0]}
  end

end
