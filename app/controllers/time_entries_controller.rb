class TimeEntriesController < ApplicationController

  before_filter :load_resources, except: :index

  def index
    collection_resource
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

  def user_report
  	collection_resource
  	@project_times = TimeEntry.report_for_collection(@time_entries)
  end

  private

  def collection_resource
    @date = Date.parse(params[:date]) if params[:date].present?
    @date ||= Date.today
    @user ||= current_user
    @time_entries = TimeEntry.for_user(@user).for_date(@date)
  end
end

