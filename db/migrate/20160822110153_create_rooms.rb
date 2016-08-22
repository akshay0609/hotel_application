class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms, :id => false do |t|
      t.string :room_id, primary_key: true
      t.integer :category_id
      t.timestamps
    end
  end
end
