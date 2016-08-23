require 'test_helper'

class BookingTest <  ActiveSupport::TestCase

  def setup
    Room.create(room_id: "A 123", category_id: 1)
    @booking = Booking.new(check_in: "2016-09-22", check_out: "2016-09-24", reason: "test application", amount: 17000, user_id: 1, room_ids: ["A 123"])
  end

  test "Should be valid" do
    assert @booking.valid?
  end

  test "check_in should be present" do
    @booking.check_in = ""
    assert_not @booking.valid?
  end

  test "check_out should be present" do
    @booking.check_out = ""
    assert_not @booking.valid?
  end

  test "reason should be present" do
    @booking.reason = ""
    assert_not @booking.valid?
  end

  test "amount should be present" do
    @booking.amount = ""
    assert_not @booking.valid?
  end

  test "rooms should be present" do
    @booking.room_ids = nil
    assert_not @booking.valid?
  end

  test "user should be present" do
    @booking.user_id = ""
    assert_not @booking.valid?
  end

  # test "Date should not be less than today date" do
  #   @booking.check_in = "2015-08-02"
  #   @booking.valid?
  #   @booking.errors[:check_in].should_not be_valid
  # end
end