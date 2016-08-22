class BookingsController < ApplicationController
  before_action :set_booking, only: [:edit, :update, :destroy, :show]
  before_action :set_category, only: [:create, :new, :update]
  before_action :authenticate_user!
  
  def index
    @booking = current_user.bookings.all
  end

  def new
    @booking  = Booking.new
  end

  def create
    @booking = Booking.new(booking_params)
    @booking.user = current_user
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
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      flash[:success] = "Room Book Successfully updated"
      redirect_to root_path
    else
      render 'edit'
    end
  end
  
  def destroy
    @booking.destroy
    flash[:danger] = "Article successfully deleted"
    redirect_to bookings_path
  end
  
  private

  def booking_params
    params.require(:booking).permit(:check_in, :check_out, :reason, room_ids: [])
  end

  def get_booking_dates_params
    params.require(:booking_dates).permit(:check_in, :check_out, :room_type)
  end
  
  def set_booking
    @booking = Booking.find(params[:id])
  end
  
  def set_category
    @category = Category.find_by(:category_type => params[:room_type])
  end
end