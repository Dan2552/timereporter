begin
  config_file = YAML.load(File.read(File.expand_path('../../podio.yml', __FILE__)))
  credentials = config_file[Rails.env].symbolize_keys

  Rails.application.config.middleware.use OmniAuth::Builder do
    provider :podio, credentials[:key], credentials[:secret]
  end

  PodioProjectFetcher.auth_key = credentials[:key]
  PodioProjectFetcher.auth_secret = credentials[:secret]
rescue
  puts "warning: podio.yml not loaded"
end
