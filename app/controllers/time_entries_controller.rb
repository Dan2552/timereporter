class TimeEntriesController < ApplicationController

  before_filter :load_resources

  def index
    @date = params[:date] || Date.today
    @start_of_week = @date.beginning_of_week
    @end_of_week = @date.end_of_week - 2
    respond_with { @time_entries }
  end

  def create
    @time_entry.user = current_user
    @time_entry.save
  end

  def update
    @time_entry.update_attributes(params[:time_entry])
  end

  def destroy
    @time_entry.destroy
  end

end

