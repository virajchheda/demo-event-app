class Invite < ApplicationRecord
  enum status: {pending: 'pending', accepted: 'accepted', rejected: 'rejected'}
  
  belongs_to :user
  belongs_to :event

  # default_scope{ where(is_owner: false) }
  scope :owned, -> { where(is_owner: true) }
  scope :not_owned, -> { where(is_owner: false) }
  scope :unowned_pending, -> { not_owned.where(status: 'pending') }
  scope :unowned_accepted, -> { not_owned.where(status: 'accepted') }
  scope :unowned_rejected, -> { not_owned.where(status: 'rejected') }

  def update_status(update_params)
    allowed = state_transition_check(self.status, update_params[:status])
    if allowed
      if self.update(update_params)
        return true 
      end
    else
      self.errors.add(:status, "has invalid transition!")
    end
    return false
  end

  def self.create_user_invite(user, event)
    invite = Invite.where(user: user, event: event).first_or_initialize
    if invite.new_record? && invite.pending!
      return true
    else
      return false, 'User already invited or User is owner'
    end
  end

  private

  def state_transition_check(from_state, to_state)
    #basic state macine like logic
    if (
      (from_state == 'pending' && (['accepted', 'rejected', 'pending'].include?(to_state))) ||
      (['accepted', 'rejected'].include?(from_state && to_state))
      )
      return true
    end
    return false
  end
end