class TimeEntriesController < ApplicationController
  before_filter :authenticate_user!

  def index
    @time_entries = TimeEntry.accessible_by(current_user)

    @date = Date.today
    @start_of_week = @date.beginning_of_week
    @end_of_week = @date.end_of_week - 2

    respond_to do |format|
      format.html
    end
  end

  def show
    @time_entry = TimeEntry.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def create
    @time_entry = TimeEntry.new(params)
    @time_entry.user = current_user

    respond_to do |format|
      if @time_entry.save
        format.js
      else
        format.html
      end
    end
  end


  def update
    @time_entry = TimeEntry.find(params[:id])
    respond_to do |format|
      if @time_entry.update_attributes(params)
        format.js
      else
        format.html
      end
    end
  end


  def destroy
    @time_entry = TimeEntry.find(params[:id])
    @time_entry.destroy

  end


end

