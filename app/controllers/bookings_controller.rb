class BookingsController < ApplicationController
  before_filter :authenticate_user_from_token!
  before_action :authenticate_user!
  before_action :set_booking, only: [:edit, :update, :destroy, :show]
  before_action :set_category, only: [:create, :new, :update]

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
      redirect_to booking_path(@booking.id)
    else
      render 'new'
    end
  end

  def show
  end

  def edit
  end

  def update
    if @booking.update(booking_params)
      flash[:success] = "Room Book Successfully updated"
      redirect_to booking_path(@booking.id)
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
    params.require(:booking).permit(:check_in, :check_out, :reason, :amount,room_ids: [])
  end
  
  def set_booking
    @booking = Booking.find(params[:id])
  end
  
  def set_category
    @category = Category.find_by(:category_type => params[:room_type])
  end
end