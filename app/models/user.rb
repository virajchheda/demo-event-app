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
   end

   def self.email_exists?(email)
    return User.where("email = ?", email).last
   end

end
