class ProjectsController < ApplicationController

  def index
    @projects = Project.all(:order => 'name ASC').group_by{|u| u.name[0]}
  end

end
