class TimeSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  attributes :project,
             :hours_text,
             :hours,
             :color

  def project
    object[0]
  end

  def hours
    object[1]
  end

  def hours_text
    pluralize(number_with_precision(object[1], strip_insignificant_zeros: true), 'hour')
  end

  def color
    Report::FLATUI_COLORS[rand(0..14)]
  end
end
