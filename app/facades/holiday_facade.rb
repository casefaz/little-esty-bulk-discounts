class HolidayFacade
  def self.holiday_information
    # binding.pry
    service = HolidayService.new
    service.holidays.shift(3).map { |data| Holiday.new(data) }
  end
end