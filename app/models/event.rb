class Event < ApplicationRecord
	has_many :invites, dependent: :destroy
	has_many :users, through: :invites do 
		def owner
			where('invites.owner = ?', true)
		end
	end

	default_scope{ order(created_at: :desc) }

	validates :event_at, :description, presence: true
	validate :event_date_cannot_be_of_past, if: Proc.new{|obj| obj.new_record? || obj.event_at_changed? }
	validates :duration, numericality: { only_integer: true, greater_than: 0 }
	validates :name, length: { maximum: 150, too_long: "should not be more than %{count} characters" }
	validates :description, length: { maximum: 1500, too_long: "should not be more than %{count} characters" }

	def event_date_cannot_be_of_past
		if event_at.present? && event_at < DateTime.now
			errors.add(:event_at, "date cannot be in past")
		end
	end

	def self.event_creation(params, user)
		event  = Event.new(params)
		if event.save
			invite = event.invites.build(user: user, status: 'accepted', owner: true)
			if invite.save
				return true, event
			end
		end
		return false, event
	end

	def self.check_owner(event_id, user)
		# byebug
		event = Event.where(id: event_id).last
		return event, (event.users.owner.ids & [user.id]).present?
	end

	def self.get_events_per_date(date, user)
		events = Event.where(event_at: (date.beginning_of_day..date.end_of_day)).sort_by &:event_at
    time_line = {}

    24.times.each do |i|
      time_line[i] = []
    end

    events.each do |e|
      color = e.invites.accepted.where(user:user).present? ? 'background' : 'none'
      time_line[e.event_at.hour] << [e.name, e.event_at, e.duration.to_i, color]
    end
    time_line
	end
end
