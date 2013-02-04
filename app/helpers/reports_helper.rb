module ReportsHelper

  def report_path object, date
    action = object.class.name.downcase.to_sym
    url_for(controller: :reports, action: action, id: object, date: date)
  end

  def hours value
    pluralize( number_with_precision(value, :strip_insignificant_zeros => true), 'hour')
  end

end
