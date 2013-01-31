module TimeEntriesHelper

	def hour_time day, hour
		date_time = day.beginning_of_day + hour.hours
	end

	def entries day, hour
		hour_datetime = hour_time(day, hour)
		@time_entries.for_date_time(hour_time(day, hour))
	end

	def hour_text hour
		(@date.beginning_of_day + hour.hours).strftime("%H:%M")
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
		@date.beginning_of_week
	end

	def end_of_week
		@date.end_of_week - 2
	end

	def week_range
		start_of_week..end_of_week
	end

	def ordinalize_date date
		"#{date.day.ordinalize} #{date.strftime '%B %Y'}"
	end
end
