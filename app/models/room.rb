class Room < ActiveRecord::Base
  self.primary_key = "room_id"

  belongs_to :category
  has_many :room_bookings, :dependent => :destroy
  has_many :bookings, through: :room_bookings

  validates :room_id, presence: true, uniqueness: true
  validates :category_id, presence: true

  def available?(check_in_date,check_out_date)
    if !self.bookings.blank? && (self.bookings.where(:check_in => check_in_date..check_out_date).count > 0 ||
                                 self.bookings.where(:check_out => check_in_date..check_out_date).count > 0 ||
                                 self.bookings.where("check_in <= ? AND check_out >= ?",check_in_date,check_out_date).count > 0) #todo make it or condition
      return false
    else
      return true
    end
  end
end