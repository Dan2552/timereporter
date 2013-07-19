class TimeEntriesController < ApplicationController

  before_filter :load_resources, except: [:index, :create]

  def index
    date_param
    @time_entries = TimeEntry.for(current_user).for_date(@date).to_a
    respond_with(@time_entries)
  end

  def create
    if params[:time_entries].present?
      @time_entries = current_user.time_entries.create(params[:time_entries].values)
    elsif params[:time_entry].present?
      @time_entry = current_user.time_entries.create(params[:time_entry])
    end
  end

  def update
    @time_entry.update_attributes(params[:time_entry])
  end

  def destroy
    @time_entry.destroy
  end

  def edit
  end

end

