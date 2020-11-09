class User < ApplicationRecord
  #devise
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # created has many through reation with events via invites
  has_many :invites, dependent: :destroy
  has_many :events, through: :invites do 
    def owned
      where('invites.owner = ?', true)
    end
    def accpted_events
      where('invites.status = ?', 'accepted')
    end
  end

  def self.email_exists?(email)
    #checking if user exist to whom invite is to be sent and returns object
    return User.where("email = ?", email.downcase).last
  end

end