module EventsHelper
  
  #helper specific to event
  
  def date_format_simple(date)
    date.present? ? date.strftime("%R %p") : ""
  end

  def formatted_duration(total_minute)
    hours = total_minute / 60
    minutes = (total_minute) % 60
    "#{ hours }:#{ minutes }"
  end

  
end
