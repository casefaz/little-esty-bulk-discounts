require 'rails_helper'

RSpec.describe 'bulk discount edit page', type: :feature do 
  describe 'merchant bulk discount edit' do 
    it 'has a prepopulated form' do 
      merch = create(:merchant)
      bulk1 = create(:bulk_discount, merchant: merch)

      visit edit_merchant_bulk_discount_path(merch.id, bulk1.id)

      expect(page).to have_field('Percentage', with: 20.0)
      expect(page).to have_field('Quantity Threshold', with: 10)
      expect(page).to have_button('Update Bulk discount')
    end
  end 
end