class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  has_many :bookings
  
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :address, presence: true, length: {minimum: 10}
  
end
