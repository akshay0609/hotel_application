module Api
  class RoomsController < ApplicationController
    before_filter :authenticate_user_from_token!
    before_action :authenticate_user!
  
    def available_rooms
      begin
        @booking_dates = get_booking_dates_params
        @category = Category.find_by(category_type: @booking_dates[:room_type])
        @rooms = @category.rooms
        @room = @rooms.select do |room|
          room if room.available?(@booking_dates[:check_in],@booking_dates[:check_out])
        end
        render json: {:room_type => @category.category_type, :amount => @category.price, :available_rooms => @room, :status=> 200 }
      rescue Exception => e
        render :nothing => true, :status => 503
      end
    end
  
    private
  
    def get_booking_dates_params
      params.permit(:check_in, :check_out, :room_type)
    end
  end
end