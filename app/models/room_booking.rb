class RoomBooking < ActiveRecord::Base
  belongs_to :room
  belongs_to :booking
end