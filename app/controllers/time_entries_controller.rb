class TimeEntriesController < ApplicationController

  before_filter :load_resources, except: :index

  def index
    date_param
    @time_entries = TimeEntry.for(current_user).for_date(@date).to_a
    respond_with(@time_entries)
  end

  def create
    #hack purely for legacy route, hopefully we can remove this not too long in the future
    @time_entry.duration = params[:time_entry][:duration_in_hours].to_f * 4

    @time_entry.user = current_user
    @time_entry.save

    respond_to do |format|
      format.html { redirect_to :back }
      format.js {}
    end
  end

  def update
    @time_entry.update_attributes(params[:time_entry])
  end

  def destroy
    @time_entry.destroy
    respond_to do |format|
      format.html { redirect_to :back }
      format.js {}
    end
  end

  def edit
  end

  def legacy
    date_param
    @time_entries = TimeEntry.for(current_user).for_date(@date, params[:duration]).to_a
  end

end

