class UserPreferencesController < ApplicationController

  def index
    @user_preferences = current_user.user_preference
  end

  def update
    @user_preferences = current_user.user_preference
    if @user_preferences.update_attributes(params[:user_preference])
      redirect_to user_preferences_path, notice: "Preferences updated"
    else
      render :index, notice: "Preferences not saved"
    end
  end

end
