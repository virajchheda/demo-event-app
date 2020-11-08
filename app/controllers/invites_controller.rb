class InvitesController < ApplicationController
  before_action :authenticate_user!
  # before_action :invite_owner_check, only: [:update_status] 
  before_action :set_invite, only: [:update_status] 

  def index
    @pending_invite = Invite.unowned_pending.where(user: current_user)
    @accepted_invite = Invite.unowned_accepted.where(user: current_user)
    @rejected_invite = Invite.unowned_rejected.where(user: current_user)
  end


  def update_status
    respond_to do |format|
      if @invite.update_status(update_params)
        format.html{ redirect_to invites_path, notice: 'Invite Successfully updated'}
      else
        format.html{ redirect_to invites_path, notice: 'Invite not Successfully updated'}
      end
    end
  end

  def create_invites
    #check if user exits
    respond_to do |format|
      if (user = User.email_exists?(params[:user_email])).present?
        event, owner_true = Event.check_owner(params[:event_id], current_user)
        #check if user is owner of event
        if owner_true && event
          success, msg = Invite.create_user_invite(user, event)
          if (success)
            # render json: {msg: 'Invite Successfully sent'}
            # format.html{ redirect_to events_path, notice: 'Invite Successfully created'}
            format.json{ render json: {msg: 'Invite Successfully created'}, status: :ok}
          else
            format.json{ render json: {msg: msg}, status: :ok}
            # render json: {msg: msg, created: :ok}
            # format.html{ redirect_to events_path, notice: msg }
          end
        else
           format.json { render json: {msg: 'Event does not exits or You are not the owner'}, status: :unprocessable_entity }
        end
      else
        format.json{ render json: {msg: 'User does not exits'}, status: :unprocessable_entity}
      end
    end
  end

  private

  def set_invite
    @invite = Invite.find(params[:id])
  end

  def update_params
    params.permit(:status)
  end
end