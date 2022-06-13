require 'rails_helper'

RSpec.describe HolidayFacade do 
  it 'returns 3 holidays' do 
    # binding.pry
    expect(HolidayFacade.holiday_information.count).to eq(3)
  end
end