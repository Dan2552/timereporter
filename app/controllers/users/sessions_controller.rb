class Users::SessionsController < Devise::SessionsController
  skip_before_filter :verify_authenticity_token, only: :create

  def create
    response.headers["X-CSRF-Token"] = form_authenticity_token
    super
  end

end