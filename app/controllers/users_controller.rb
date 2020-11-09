class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :get_date, only: [:dashboard]

  def dashboard
    #user dashboard 
    #if date is present search as per date or else today's date is considered
    param_date = get_date
    @date = param_date.present? && param_date[:date].present? ? Date.parse(param_date[:date]) : Date.today
    @time_line = Event.get_events_per_date(@date, current_user)
  end

  def invite
    #get other users invites as per states
    @pending_invite = current_user.invites.includes(:event).unowned_pending # Invite.unowned_pending.where(user: current_user)
    @accepted_invite = current_user.invites.includes(:event).unowned_accepted #Invite.include(:user).unowned_accepted.where(user: current_user)
    @rejected_invite = current_user.invites.includes(:event).unowned_rejected #Invite.unowned_rejected.where(user: current_user)
  end

  private
  
  def get_date 
    #check for passing date if date is present or else Date.today will be considered  
    if params.present? && params.key?(:search_date)
      params.require(:search_date).permit(:date)
    end
  end
end


