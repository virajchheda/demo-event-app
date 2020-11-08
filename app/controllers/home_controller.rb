class HomeController < ApplicationController
  before_action :authenticate_user!
  before_action :get_date, only: [:index]

  def index
    param_date = get_date
    @date = param_date.present? && param_date[:date].present? ? Date.parse(param_date[:date]) : Date.today
    @time_line = Event.get_events_per_date(@date, current_user)
  end

  private
  def get_date 
    #check for passing date if date is present or else Date.today will be considered  
    if params.present? && params.key?(:search_date)
      params.require(:search_date).permit(:date)
    end
  end
end


