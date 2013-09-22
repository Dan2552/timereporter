module TimeEntriesHelper

	def hour_time day, hour
		day.beginning_of_day + hour.hours
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
      "#{ordinalize_date(start)} - #{stop.day.ordinalize} #{stop.strftime('%b')}"
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
		"#{date.day.ordinalize} #{date.strftime '%b %Y'}"
	end

	def project_name_for_time_entry time_entry
		if time_entry.project.present?
			"<p class=\"project-text\">#{time_entry.project.try(:name)}</p>".html_safe
		end
	end

	def comments_for_time_entry time_entry
		if time_entry.comment.present?
			if time_entry.duration >= 2
				"<p class=\"comment-text\">#{time_entry.try(:comment)}</p>".html_safe
			end
		end
	end

	def main_hour_class hour
		if hour > 8.25 && hour < 17.5
			"main-hour"
		end
	end

	def day_title day
		content_tag :div, class:'title' do
			[content_tag(:h4, day.strftime("%A, %b %-d"), class:'large'), content_tag(:h4, day.strftime("%a, %b %-d"), class:'small')].join().html_safe
		end
	end

	def quarter_hour_slot day, hour, options = {}
		div_classes = [options.delete(:class), 'quarter-hour'].join(' ')
		data = {:'datetime' => hour_time(day, hour).strftime("%Y/%m/%d %H:%M:%S"), :'start' => hour_text(hour), :"end" => hour_text(hour + 0.25)}

		content_tag :div, render(entries(day, hour)), class: div_classes, data: data
	end
end
