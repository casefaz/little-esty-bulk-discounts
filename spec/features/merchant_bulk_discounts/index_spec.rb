require 'rails_helper'

RSpec.describe 'merchant bulk discount index page', type: :feature do 
  describe 'bulk discounts index' do 
    it 'displays all the attributes of the bulk discounts' do 
      merch = create(:merchant)
      merch2 = create(:merchant)

      bulk1 = create(:bulk_discount, merchant: merch)
      bulk2 = create(:bulk_discount, merchant: merch, quantity_threshold: 5, percentage: 15)
      bulk3 = create(:bulk_discount, merchant: merch, quantity_threshold: 15, percentage: 30)
      bulk4 = create(:bulk_discount, merchant: merch2)

      visit merchant_bulk_discounts_path(merch.id)

      expect(page).to have_content("Bulk Discounts")

      within "#discount-#{bulk1.id}" do 
        expect(page).to have_content('Discount: %20')
        expect(page).to have_content('Max Quantity: 10')
      end

      within "#discount-#{bulk2.id}" do 
        expect(page).to have_content('Discount: %15')
        expect(page).to have_content('Max Quantity: 5')
      end

      within "#discount-#{bulk3.id}" do 
        expect(page).to have_content('Discount: %30')
        expect(page).to have_content('Max Quantity: 15')
      end
      expect(page).to_not have_content(bulk4.id)
    end

    it 'has a link for each bulk discount' do 
      merch = create(:merchant)
      merch2 = create(:merchant)

      bulk1 = create(:bulk_discount, merchant: merch)
      bulk2 = create(:bulk_discount, merchant: merch, quantity_threshold: 5, percentage: 15)
      bulk3 = create(:bulk_discount, merchant: merch, quantity_threshold: 15, percentage: 30)
      bulk4 = create(:bulk_discount, merchant: merch2)

      visit merchant_bulk_discounts_path(merch.id)

      within "#discount-#{bulk1.id}" do 
        expect(page).to have_content('Discount: %20')
        expect(page).to have_content('Max Quantity: 10')
        expect(page).to have_link("##{bulk1.id} Discount Information")
      end

      within "#discount-#{bulk2.id}" do 
        expect(page).to have_content('Discount: %15')
        expect(page).to have_content('Max Quantity: 5')
        expect(page).to have_link("##{bulk2.id} Discount Information")
      end

      within "#discount-#{bulk3.id}" do 
        expect(page).to have_content('Discount: %30')
        expect(page).to have_content('Max Quantity: 15')
        expect(page).to have_link("##{bulk3.id} Discount Information")
        click_link "##{bulk3.id} Discount Information"
      end
      expect(current_path).to eq("/merchants/#{merch.id}/bulk_discounts/#{bulk3.id}")
      expect(page).to_not have_link "##{bulk4.id} Discount Information"
    end
  end
end