require 'rails_helper'

RSpec.describe 'form for new discount', type: :feature do 
  describe 'merchant bulk discount create' do 
    it 'has a form to add a new bulk discount' do 
      merch = create(:merchant)
      
      visit new_merchant_bulk_discount_path(merch.id)
      expect(page).to have_content("New Form")
      fill_in('bulk_discount[percentage]', with: 42)
      fill_in('bulk_discount[quantity_threshold]', with: 5)
      click_on('Submit')
      expect(current_path).to eq merchant_bulk_discounts_path(merch.id)
    end
  end
end