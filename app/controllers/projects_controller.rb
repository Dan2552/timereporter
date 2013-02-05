class ProjectsController < ApplicationController

  def index
    @projects = Project.ordered_by_title.group_by{|u| u.title[0]}
  end

  def show
    @project = Project.find(params[:id])
  end

end
