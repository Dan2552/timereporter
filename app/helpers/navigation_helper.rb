module NavigationHelper
  def get_class(link_name)
    params[:controller].include?(link_name) ? "active" : ""
  end
end