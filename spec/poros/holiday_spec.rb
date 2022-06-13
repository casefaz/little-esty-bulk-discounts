require 'rails_helper'

RSpec.describe Holiday do 
  it 'exists and has attributes' do 
    holidays = Holiday.new({name: 'Free Comic Day', date: '07-02-2022'})

    expect(holidays).to be_an_instance_of(Holiday)
    expect(holidays.name).to eq('Free Comic Day')
    expect(holidays.date).to eq('07-02-2022')
  end 
end