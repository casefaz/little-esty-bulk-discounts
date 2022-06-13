require 'rails_helper'

RSpec.describe Holiday do 
  holidays = Holiday.new({name: 'Free Comic Day', date: '07-02-2022'})

  expect(holidays).to be_an_instance_of(Holiday)
  expect(holidays.upcoming_holidays).to be_a(Hash)
end