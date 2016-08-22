class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :check_in
      t.date :check_out
      t.string :reason
      t.timestamps
    end
  end
end
