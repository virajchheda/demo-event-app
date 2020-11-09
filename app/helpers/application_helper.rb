module ApplicationHelper
  
  #placing these methods here as they are used in multiple views
  
  def date_format(date)
    date.present? ? date.strftime("%a, %b %e %Y, %R %p") : ""
  end

  def formatted_duration_hh_mm(total_minute)
    hours = total_minute / 60
    minutes = (total_minute) % 60
    "#{ hours }h :#{ minutes } mins"
  end
end
