class PodioSessionsController < ApplicationController

  CLIENT_ID = "timereporter2"

  def new
    return_url = podio_sessions_url
    redirect_to "https://podio.com/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{return_url}"
  end

  def index
    results = Project.fetch_remote_projects(auth_code: params[:code], path: root_url)
    redirect_to projects_url, notice: "#{results.count} projects from Podio found"
  end

end
