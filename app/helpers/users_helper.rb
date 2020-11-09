module UsersHelper

  #helper specific to users
  
  def non_time_format_simple(date)
    date.present? ? date.strftime("%a, %b %e %Y") : ""
  end

  def hour_format(time)
    parsed_time = Time.parse(time.to_s+":00")
    parsed_time.present? ? parsed_time.strftime("%H %p") : ""
  end

end
