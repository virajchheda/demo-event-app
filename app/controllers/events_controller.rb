class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: [:show, :edit, :update, :destroy]
  before_action :event_owner_check, only: [:edit, :update, :destroy]
  # before_action :set_user, only: [:index]/

  def index
    #get all events that user wons
    @events = Event.includes(:invites).where({invites: {owner: true, user: current_user}})
  end

  def event_owner_check
    #check if the user is not trying to edit other user's event
    unless @event.users.owner.ids.present? && @event.users.owner.ids & [current_user.id]
      flash[:notice] = 'Access denied as you are not owner of this Event'
      redirect_to events_path
    end 
  end

  def show
    #show will redirect to events page
    redirect_to events_path
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    #calling model's method for evet creation as event creation will required entry in invite table
    status, @event = Event.event_creation(updated_params, current_user)
    respond_to do |format|
      if status
        format.html { redirect_to events_path, notice: 'Event was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @event.update(updated_params)
        format.html { redirect_to events_path, notice: 'Event was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to events_url, notice: 'Event was successfully destroyed.' }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:name, :description, :event_at, :duration)
    end

    #update params in needed as we are storing duration in minutes term
    #so 2h: 00m will be converted to 2 * 60 = 120 minutes and stores
    def updated_params
      updated_params = event_params
      if updated_params["duration"]
        updated_params["duration"] = duration_in_minutes(updated_params["duration"])
        updated_params
      end
    end

    #method for converting hh:mm to minutes
    def duration_in_minutes(hour_minute)
      h_array = hour_minute.to_s.split(":")
      minutes = h_array[0].to_i * 60
      total_minute = minutes + h_array[1].to_i
      total_minute
    end
end
