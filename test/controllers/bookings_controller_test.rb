require "test_helper"

class BookingsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    sign_in users(:one)
    @category = Category.create(category_type:"Luxury Rooms", facility:"Queen size Bed and pool facing", price:8500)
    @room     = Room.create(room_id: "A 125", category_id: 1)
    @room     = Room.create(room_id: "A 126", category_id: 1)
    @booking  = Booking.create(check_in: Date.today, check_out: Date.today, reason: "test application", amount: 17000, user_id: 1, room_ids: ["A 125"])
  end
  
  test "should get bookings index" do
    get :index
    assert_response :success
  end
  
  test "should get new" do
    get(:new, { :room_type => @category.category_type } )
    assert_response :success
  end
  
  test "should get show" do
    get(:show, { :id => @booking.id } )
    assert_response :success
  end

  test "should create new booking" do
    post(:create, { booking: {check_in: Date.today, check_out: Date.today, reason: "test application", amount: 17000, user_id: 1, room_ids: ["A 126"] }, room_type: "Deluxe Rooms" })
    assert_redirected_to booking_path(Booking.last)
    assert_not_nil Booking.find_by(check_in: Date.today,check_out: Date.today)
  end

  test "should get edit" do
    get(:edit, { :id => @booking.id } )
    assert_response :success
  end

  test "should update booking" do
    patch(:update, { booking: {check_in: Date.today, check_out: Date.today, reason: "test application for update", amount: 17000, user_id: 1, room_ids: ["A 125"] }, room_type: "Luxury Rooms", id: @booking.id })
    assert_redirected_to booking_path(@booking.id)
    assert_not_nil Booking.find_by(reason: "test application for update")
  end

  test "should delete booking" do
    booking_id = @booking.id
    delete(:destroy, { id: booking_id })
    assert_redirected_to bookings_path
    assert_nil Booking.find_by(id: booking_id)
  end
end