class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

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
    #checking if user exist to whom invite is to be sent
    return User.where("email = ?", email).last
  end

end