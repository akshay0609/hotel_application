class BookingsController < ApplicationController

  def index
    @booking = Booking.all
  end

  def new
    @category = Category.find_by(:category_type => params[:room_type])
    @booking  = Booking.new
  end

  def create
    @category = Category.find_by(:category_type => params[:room_type])
    @booking = Booking.new(booking_params)
    if @booking.valid?
      @booking.save
      flash[:success] = "Room Book Successfully"
      redirect_to root_path
    else
      render 'new'
    end
  end

  def available_rooms
    @booking_dates = get_booking_dates_params
    @rooms = Category.find_by(category_type: @booking_dates[:room_type]).rooms
    @room = @rooms.select do |room|
      room if room.available?(@booking_dates[:check_in],@booking_dates[:check_out])
    end
    render json: @room
  end

  def show
    @booking = Booking.find(params[:id])
  end

  def edit
    @booking = Booking.find(params[:id])
  end

  private

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :reason, room_ids: [])
  end

  def get_booking_dates_params
    params.require(:booking_dates).permit(:check_in, :check_out, :room_type)
  end
end