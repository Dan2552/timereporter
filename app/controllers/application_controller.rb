class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

  respond_to :json, :html, :js
  def verified_request?
    if request.content_type == "application/json"
      if params[:api_token].present? && params[:api_token] == current_user.try(:api_token)
        true
      else
        respond_with({ errors: "API token mismatch" }, status: 401)
        false
      end
    else
      super
    end
  end

  private

  def set_layout
    user_signed_in? ? "application" : "devise"
  end
end
