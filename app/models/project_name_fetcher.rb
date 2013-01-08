class ProjectNameFetcher

  def self.fetch
    #OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    Podio.setup api_key: 'timereporter2', api_secret: 'FO5dAQAKqZEEKh04HDEguoIzoLfAuc6bUB6UC0nlTBfSqT3DM4QcTK9CgtALLmIO'
    Podio.client.authenticate_with_credentials 'daniel.green@alliants.co.uk', p

    Podio::Item.find_all(2226608, :limit => 500)[0].each do |project|
      title = project.title
      client = project.fields.map { |i| i["values"][0]["value"]["title"] }.compact.first
      #puts title.to_s + ", " + client.to_s
      add_project title, client
    end
  end

  def self.add_project project, client
    project = project.to_s
    client = client.to_s

    return unless project.present?

    change = false

    project_name = ProjectName.find_by_value(project)
    if project_name.nil?
      project_name = ProjectName.new(value: project)
      change = true
    end

    if client.present?
      client_name = ClientName.find_by_value(client)
      if client_name.nil?
        client_name = ClientName.new(value: client)
      end

      if project_name.client_name != client_name
        project_name.client_name = client_name
        change = true
      end

    end

    project_name.save if change
  end

end