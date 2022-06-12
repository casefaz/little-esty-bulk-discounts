require 'rails_helper'

RSpec.describe 'Form For New Discount', type: :feature do 
  describe 'Merchant Bulk Discount Create' do 
    it 'has a form to add a new bulk discount' do 
      merch = create(:merchant)
      visit new_merchant_bulk_discount_path(merch.id)

      expect(page).to have_content("New Form")
      fill_in('Percentage', with: 42)
      fill_in('Quantity Threshold', with: 5)
      click_on('Create Bulk discount')
      expect(current_path).to eq merchant_bulk_discounts_path(merch.id)
    end

    it 'doesnt work if field is left blank' do 
      merch = create(:merchant)
      visit new_merchant_bulk_discount_path(merch.id)
    
      expect(page).to have_content("New Form")
      fill_in('Percentage', with: 42)
      click_on('Create Bulk discount')
      expect(current_path).to eq(new_merchant_bulk_discount_path(merch.id))
      expect(page).to have_content("Error: Missing Field")
    end

    it 'displays new discount on index page' do 
      merch = create(:merchant)
      visit new_merchant_bulk_discount_path(merch.id)

      expect(page).to have_content("New Form")
      fill_in('Percentage', with: 42)
      fill_in('Quantity Threshold', with: 5)
      click_on('Create Bulk discount')
      expect(current_path).to eq merchant_bulk_discounts_path(merch.id)
      expect(page).to have_content('Discount: %42')
      expect(page).to have_content('Success! Discount Created')
    end
  end
end