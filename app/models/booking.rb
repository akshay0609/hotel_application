class Booking < ActiveRecord::Base
  has_many :room_bookings, :dependent => :destroy
  has_many :rooms, through: :room_bookings
  belongs_to :user

  validates :check_in, presence: true
  validates :check_out, presence: true
  validates :reason, presence: true, length: {minimum: 5}
  validates :amount, presence: true
  validates :user_id, presence: true
  validates :rooms, presence: true
  
  validate :check_in_date_cannot_be_in_the_past
  validate :check_out_date_cannot_be_in_the_past

  def check_in_date_cannot_be_in_the_past
    if check_in.present? && check_in < Date.today && check_out > (Date.today >> 6)
      errors.add(:check_in, "Date must be higher or equal to today")
    end
  end

  def check_out_date_cannot_be_in_the_past
    if check_out.present? && check_in.present? && (check_out < Date.today || check_out < check_in) && check_in > (Date.today >> 6)
      errors.add(:check_out, "Date must be higher or equal to today and check_in date")
    end
  end
end