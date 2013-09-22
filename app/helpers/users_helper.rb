module UsersHelper

  def avatar_for(email)
    content_tag :div, image_tag(email), class:'avatar'
  end

end
