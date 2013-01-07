class Users::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    if request.format == 'application/json'
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      resource.generate_api_token
      respond_with resource, location: after_sign_in_path_for(resource)
    else
      super
    end
  end

end