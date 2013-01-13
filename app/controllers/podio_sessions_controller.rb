class PodioSessionsController < ApplicationController

  CLIENT_ID = "timereporter2"

  def new
    return_url = podio_sessions_url
    redirect_to "https://podio.com/oauth/authorize?client_id=#{CLIENT_ID}&redirect_uri=#{return_url}"
  end

  def index
    auth_code = params[:code]
    count = ProjectNameFetcher.fetch auth_code, root_url
    redirect_to projects_url, notice: "#{count} projects from Podio found"
  end

end
