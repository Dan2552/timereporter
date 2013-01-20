class ApplicationController < ActionController::Base
  protect_from_forgery
  layout :set_layout

  private

  def set_layout
    user_signed_in? ? "application" : "devise"
  end
end
