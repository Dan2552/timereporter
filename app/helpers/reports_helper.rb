module ReportsHelper

  def report_path object, date
    action = object.class.name.downcase.to_sym
    url_for(controller: :reports, action: action, id: object, date: date)
  end

  def hours value
    pluralize(number_with_precision(value, strip_insignificant_zeros: true), 'hour')
  end

  def days value
    pluralize(number_with_precision(value, strip_insignificant_zeros: true), 'day')
  end

  def toggle_link name
    toggled = params[name].true? ? "Unfilter" : "Filter"
    title = "#{toggled} #{name.to_s.titleize}"
    link_to title, url_with_param(name, params[name].false?), class: "btn #{'active' if params[name].true?}"
  end

  def url_with_param(key, value)
    parameters = filtered_params.dup.tap { |p| p.delete(key) }
    parameters[key.to_sym] = value.to_s if value
    url_for(:params => parameters)
  end

  def filtered_params
    params.dup.tap do |p| 
      p.delete("action")
      p.delete("controller")
    end
  end

  def action? action
    params[:action] == action
  end

  def using_filter?
    Project::FILTERABLE.each { |f| return true if params[f].true? }
    false
  end

end
