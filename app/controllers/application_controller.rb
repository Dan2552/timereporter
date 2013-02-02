class ApplicationController < ActionController::Base
	include LazyResourceLoader
  protect_from_forgery
  layout :set_layout
  before_filter :authenticate_user!

  respond_to :html, :js, :json

  private

  def set_layout
    user_signed_in? ? "application" : "devise"
  end

  protected

  def date_param
    @date = Date.parse(params[:date]) if params[:date].present?
    @date ||= Date.today
  end

end
