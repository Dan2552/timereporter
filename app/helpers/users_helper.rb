module UsersHelper

  def avatar
    content_tag :div, image_tag(current_user.gravatar_url), class:'avatar'
  end

end
