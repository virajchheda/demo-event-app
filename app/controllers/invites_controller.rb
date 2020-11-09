class InvitesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_invite, only: [:update_status] 


  def update_status
    #updating invites status
    respond_to do |format|
      if @invite.update_status(update_params)
        format.html{ redirect_to users_invite_path, notice: 'Invite Successfully updated'}
      else
        format.html{ redirect_to users_invite_path, notice: 'Invite not Successfully updated'}
      end
    end
  end

  def create_invites
    respond_to do |format|
      #check if user exits
      if (user = User.email_exists?(params[:user_email])).present?
        #check if user is owner of event
        event, owner_true = Event.check_owner(params[:event_id], current_user)
        if owner_true && event
          success, msg = Invite.create_user_invite(user, event)
          if (success)
            format.json{ render json: {msg: 'Invite Successfully created'}, status: :ok}
          else
            format.json{ render json: {msg: msg}, status: :ok}
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
    #only permit status 
    params.permit(:status)
  end
end