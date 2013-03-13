class PodioSessionsController < ApplicationController

  def new
    return_url = podio_sessions_url
    client = PodioProjectFetcher.auth_key
    redirect_to "https://podio.com/oauth/authorize?client_id=#{client}&redirect_uri=#{return_url}"
  end

  def index
    old_count = Project.all.count
    results = Project.fetch_remote_projects(auth_code: params[:code], path: root_url)
    new_count = Project.all.count
    difference = new_count - old_count
    redirect_to projects_url, notice: "#{results.count} projects from Podio found (#{difference} are new)."
  end

end
