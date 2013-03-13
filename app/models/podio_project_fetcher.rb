class PodioProjectFetcher
  class << self
    attr_accessor :auth_key, :auth_secret 
  end

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
    Podio.setup api_key: self.class.auth_key, api_secret: self.class.auth_secret
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
    value["value"] || value["text"] || value["name"] || value["title"] || (value if value.is_a?(String))
  end

end
