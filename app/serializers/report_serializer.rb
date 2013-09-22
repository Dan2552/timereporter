class ReportSerializer < ActiveModel::Serializer
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper
  self.root = false
  attributes :report_item_name,
             :gravatar_url,
             :days,
             :total_hours

  has_many :times, serializer: TimeSerializer

  def report_item_name
    object.object.name
  end

  def gravatar_url
    if object.object.is_a?(User)
      object.object.gravatar_url
    end
  end

  def days
    pluralize(number_with_precision(object.days, strip_insignificant_zeros: true), 'day')
  end

  def total_hours
    pluralize(number_with_precision(object.total, strip_insignificant_zeros: true), 'hour')
  end

end
