module EventsHelper
  def date_format(date)
    date.present? ? date.strftime("%a, %b %e %Y, %R %p") : ""
  end
  def date_format_simple(date)
    date.present? ? date.strftime("%R %p") : ""
  end

  def non_time_format_simple(date)
    date.present? ? date.strftime("%a, %b %e %Y") : ""
  end

  def hour_format(time)
    parsed_time = Time.parse(time.to_s+":00")
    parsed_time.present? ? parsed_time.strftime("%H %p") : ""
  end

  def formatted_duration(total_minute)
    hours = total_minute / 60
    minutes = (total_minute) % 60
    "#{ hours }:#{ minutes }"
  end

  def formatted_duration_hh_mm(total_minute)
    hours = total_minute / 60
    minutes = (total_minute) % 60
    "#{ hours }h :#{ minutes } mins"
  end
  
end
