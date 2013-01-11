class ProjectsController < ApplicationController

  def index
    @projects = ProjectName.all
  end

end
