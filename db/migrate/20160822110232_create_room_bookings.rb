class CreateRoomBookings < ActiveRecord::Migration
  def change
    create_table :room_bookings do |t|
      t.string :room_id
      t.integer :booking_id
    end
  end
end
