class PodioProjectFetcher
  KEY = 'timereporter2'
  SECRET = 'FO5dAQAKqZEEKh04HDEguoIzoLfAuc6bUB6UC0nlTBfSqT3DM4QcTK9CgtALLmIO'

  def initialize(args = {})
    @auth_code = args[:auth_code]
    @path = args[:path]

    authenticate_api
  end

  def fetch
    remote_projects.each { |p| Project.create_or_update(p.field_values) }
  end

  protected

  def project_with_title(title)
    remote_projects.each { |p| return p if p.title == title }
    nil
  end

  def authenticate_api
    Podio.setup api_key: KEY, api_secret: SECRET
    Podio.client.authenticate_with_auth_code(@auth_code, @path)
  end

  def remote_projects
    Podio::Item.find_all(2226608, :limit => 500)[0]
  end

end


class Podio::Item

  def field_keys
    fields.map { |field| field["external_id"] }
  end

  def field_values
    values = {}
    field_keys.each { |key| values[key.underscore.to_sym] = field_value(key) }
    values
  end

  def field_value(key)
    value = fields.map{ |f| f["external_id"] == key ? f : nil }.compact.first["values"][0]["value"]
    return value["value"] if value["value"].present?
    return value["text"] if value["text"].present?
    return value["name"] if value["name"].present?
    return value["title"] if value["title"].present?
    return value if value.is_a? String
    nil
  end

end
