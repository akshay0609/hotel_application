class BookingSweeper < ActionController::Caching::Sweeper
  observe Booking 
  
  def sweep(booking)
    expire_page bookings_path
    expire_page booking_path(booking)
    FileUtils.rm_rf "#{page_cache_directory}/deploy"
  end
  alias_method :after_update, :sweep
  alias_method :after_create, :sweep
  alias_method :after_destroy, :sweep
end