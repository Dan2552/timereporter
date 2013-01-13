class ProjectsController < ApplicationController

  def index
    @projects = ProjectName.all(:order => 'value ASC').group_by{|u| u.value[0]}
  end

end
