class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.date :check_in
      t.date :check_out
      t.string :reason
      t.integer :amount
      t.integer :user_id
      t.timestamps
    end
  end
end
