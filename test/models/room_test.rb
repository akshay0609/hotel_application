require 'test_helper'

class RoomTest < ActiveSupport::TestCase

  def setup
    Category.create(category_type:"Deluxe Rooms",facility:"Queen size Bed",price:7000)
    @room = Room.new(room_id: "A 123", category_id: 1)
  end

  test "Should be valid" do
    assert @room.valid?
  end

  test "room_id should be present" do
    @room.room_id = " "
    assert_not @room.valid?
  end

  test "category should be present" do
    @room.category = nil
    assert_not @room.valid?
  end

  test "email should be unique" do
    room = @room.dup
    @room.save
    assert_not room.valid?
  end
end