require 'rails_helper'

RSpec.describe HolidayFacade do 
  it 'returns 3 holidays' do 
    holiday_facade = HolidayFacade.new
    expect(holiday_facade.holiday_information.count).to eq(3)
  end
end