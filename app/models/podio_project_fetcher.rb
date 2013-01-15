class PodioProjectFetcher
  KEY = 'timereporter2'
  SECRET = 'FO5dAQAKqZEEKh04HDEguoIzoLfAuc6bUB6UC0nlTBfSqT3DM4QcTK9CgtALLmIO'

  def initialize(args = {})
    @auth_code = args[:auth_code]
    @path = args[:path]

    authenticate_api
  end

  def fetch
    remote_projects.each { |p| add_project(p.title, project_client(p)) }
  end

  protected

  def project_client(project)
    project.fields.map { |i| i["values"][0]["value"]["title"] }.compact.first
  end

  def authenticate_api
    Podio.setup api_key: KEY, api_secret: SECRET
    Podio.client.authenticate_with_auth_code(@auth_code, @path)
  end

  def remote_projects
    Podio::Item.find_all(2226608, :limit => 500)[0]
  end

  def add_project(name, client_name)
    project = Project.lazy_find_by_name(name.to_s)
    client = Client.lazy_find_by_name(client_name.to_s)
    project.client = client if client.present? && client.valid?
    project.save
  end

end