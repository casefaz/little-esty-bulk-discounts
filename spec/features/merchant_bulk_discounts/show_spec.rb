require 'rails_helper'

RSpec.describe 'merchant bulk discounts show page', type: :feature do 
  describe 'merchant bulk discount show' do 
    it 'shows a specific bulk discounts attributes' do 
      merch = create(:merchant)
      bulk1 = create(:bulk_discount, merchant: merch)
      bulk2 = create(:bulk_discount, merchant: merch, quantity_threshold: 5, percentage: 15)

      visit merchant_bulk_discount_path(merch.id, bulk1.id)
      expect(page).to have_content("Discount ##{bulk1.id}")
      expect(page).to have_content(bulk1.percentage)
      expect(page).to have_content(bulk1.quantity_threshold)
      expect(page).to_not have_content("Discount ##{bulk2.id}")
      expect(page).to_not have_content(bulk2.percentage)
    end
  end
end