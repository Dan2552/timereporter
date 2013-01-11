Rails.application.config.middleware.use OmniAuth::Builder do
  provider :podio, ENV['timereporter2'], ENV['FO5dAQAKqZEEKh04HDEguoIzoLfAuc6bUB6UC0nlTBfSqT3DM4QcTK9CgtALLmIO']
end