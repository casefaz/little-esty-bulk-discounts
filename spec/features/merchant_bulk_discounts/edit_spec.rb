require 'rails_helper'

RSpec.describe 'Bulk Discount Edit Page', type: :feature do 
  describe 'Merchant Bulk Discount Edit' do 
    it 'has a prepopulated form' do 
      merch = create(:merchant)
      bulk1 = create(:bulk_discount, merchant: merch)

      visit edit_merchant_bulk_discount_path(merch.id, bulk1.id)

      expect(page).to have_field('Percentage', with: 20.0)
      expect(page).to have_field('Quantity Threshold', with: 10)
      expect(page).to have_button('Update Bulk discount')
    end

    it 'updates discount information on submit' do 
      merch = create(:merchant)
      bulk1 = create(:bulk_discount, merchant: merch)

      visit edit_merchant_bulk_discount_path(merch.id, bulk1.id)

      fill_in('Percentage', with: 30)
      fill_in('Quantity Threshold', with: 15)
      click_on('Update Bulk discount')
      expect(current_path).to eq merchant_bulk_discount_path(merch.id, bulk1.id)

      expect(page).to have_content('Percentage: 30.0%')
      expect(page).to have_content('Quantity Threshold: 15')
      expect(page).to_not have_content('Percentage: 20.0%')
      expect(page).to_not have_content('Quantity Threshold: 10')
    end

    it 'cant be updated without necessary information included' do 
      merch = create(:merchant)
      bulk1 = create(:bulk_discount, merchant: merch)

      visit edit_merchant_bulk_discount_path(merch.id, bulk1.id)

      fill_in('Percentage', with: '')
      click_on('Update Bulk discount')
      expect(current_path).to eq(edit_merchant_bulk_discount_path(merch.id, bulk1.id))
      expect(page).to have_content('Discount not updated, add missing field')
    end
  end 
end