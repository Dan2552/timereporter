module ApplicationHelper

  def retro comment
    nineties = image_tag("90s.jpg", size: "30x30")
    "#{nineties} <strong>#{comment}</strong> #{nineties}".html_safe
  end

end
