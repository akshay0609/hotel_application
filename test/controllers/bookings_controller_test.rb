require "test_helper"

class BookingsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    sign_in users(:one)
    @category = Category.create(category_type:"Luxury Rooms", facility:"Queen size Bed and pool facing", price:8500)
    @room     = Room.create(room_id: "A 125", category_id: 1)
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
    get(:show, { :id => @category.id } )
    assert_response :success
  end
end