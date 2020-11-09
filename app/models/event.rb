class Event < ApplicationRecord

  # created has many through reation with users via inites
  has_many :invites, dependent: :destroy
  has_many :users, through: :invites do 
    def owner
      where('invites.owner = ?', true)
    end
  end

  default_scope{ order(created_at: :desc) }

  #basic validations
  validates :name, length: { maximum: 150, too_long: "should not be more than %{count} characters" }
  validates :description, length: { maximum: 1500, too_long: "should not be more than %{count} characters" }
  validates :event_at, :description, presence: true
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  validate :event_date_cannot_be_of_past, if: Proc.new{|obj| obj.new_record? || obj.event_at_changed? }

  def event_date_cannot_be_of_past
    if event_at.present? && event_at < DateTime.now
      errors.add(:event_at, "date cannot be in past")
    end
  end

  def self.event_creation(params, user)
    #creating evnt will also create entry in Invite table with owner: true and status as accepted
    event  = Event.new(params)
    if event.save
      invite = event.invites.build(user: user, owner: true)
      if invite.save && invite.accepted!
        return true, event
      end
    end
    return false, event
  end

  def self.check_owner(event_id, user)
    #owner checking before sending invites and send's object and true/false depending on the current user's ownership
    event = Event.where(id: event_id).last
    return event, (event.users.owner.ids & [user.id]).present?
  end

  def self.get_events_per_date(date, user)

    time_line = {}

    #first get all events for that day
    day_events = Event.unscoped.where(event_at: (date.beginning_of_day..date.end_of_day)).sort_by &:event_at
    #get user's accepted event
    user_events = user.events.accpted_events.where(event_at:(date.beginning_of_day..date.end_of_day))

    #24 for representing 24hrs
    24.times.each do |i|
      time_line[i] = []
    end

    day_events.each do |e|
      # check if event is present in user's accepted events 
      # then make colored if the user has accepted event or else leave it blank
      color = user_events.include?(e) ? 'background' : 'none'
      time_line[e.event_at.hour] << [e.name, e.event_at, e.duration.to_i, color]
    end
    
    time_line
  end
end
