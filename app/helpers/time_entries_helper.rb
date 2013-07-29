module TimeEntriesHelper

	def hour_time day, hour
		date_time = day.beginning_of_day + hour.hours
	end

	def entries day, hour
		@time_entries.where(entry_datetime: hour_time(day, hour))
	end

	def hour_text hour
		(@date.beginning_of_day + hour.hours).strftime("%H:%M")
	end

	def duration_param
		Duration.new(params[:duration]).value
	end

	def date_range_text
		start = start_of_week
		stop = end_of_week
		if (start.year == stop.year) and (start.month == stop.month)
      "#{start.day}-#{ordinalize_date(stop)}"
    else
      "#{ordinalize_date(start)} - #{ordinalize_date(stop)}"
    end
	end

	def start_of_week
		@date.send("beginning_of_#{duration_param}")
	end

	def end_of_week
		if duration_param == :week
			@date.end_of_week - 2
		else
			@date.send("end_of_#{duration_param}")
		end
	end

	def week_range
		start_of_week..end_of_week
	end

	def ordinalize_date date
		"#{date.day.ordinalize} #{date.strftime '%B %Y'}"
	end

	def project_name_for_time_entry time_entry
		if time_entry.project.present?
			if time_entry.duration > 1
				"<p class=\"project-text\"><span>Project:</span><br>#{time_entry.project.try(:name)}</p>".html_safe
			else
				"<p class=\"project-text\">#{time_entry.project.try(:name)}</p>".html_safe
			end
		end
	end

	def comments_for_time_entry time_entry
		if time_entry.comment.present?
			if time_entry.duration >= 2
				"<p class=\"comment-text\"><span>Comments:</span><br>#{time_entry.try(:comment)}</p>".html_safe
			end
		end
	end

	def main_hour_class hour
		if hour > 8.25 && hour < 17.5
			"main-hour"
		end
	end
end
