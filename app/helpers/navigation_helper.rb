module NavigationHelper
  def get_class(link_name)
    path = request.fullpath.split('/')[1]
    path = "time_entries" if path.blank?
    path[link_name] ? "active" : ""
  end
end