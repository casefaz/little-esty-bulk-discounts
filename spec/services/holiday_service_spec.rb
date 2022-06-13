require 'rails_helper'

RSpec.describe HolidayService do 
  it 'gets holiday information from the API' do 
    holiday_service = HolidayService.new
    json = holiday_service.holidays
    # binding.pry
    expect(holiday_service).to be_an_instance_of(HolidayService)
    expect(json).to be_a(Array)
    expect(json[0]).to have_key(:localName)
    expect(json[0]).to have_key(:date)
  end
end