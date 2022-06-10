require 'rails_helper'

RSpec.describe "Admin Merchants Index Page ", type: :feature do
  describe 'User Story 1 - Admin Merchants Index' do

    it "can display all the merchants" do
      merchants2 = create_list(:merchant, 2, status: 0)
      visit '/admin/merchants'

      expect(page).to have_content(merchants2[0].name)
      expect(page).to have_content(merchants2[1].name)
    end
  end

  describe "Admin Merchant Enable/Disable" do
    it "has a button to disable or enable each merchant and updates status" do
      merchants = create_list(:merchant, 6, status: 1)
      merchants2 = create_list(:merchant, 2, status: 0)

      visit '/admin/merchants'

      expect(merchants[0].status).to eq("enabled")
      within "#enabled-#{merchants[0].id}" do
        click_button "Disable"
      end

      expect(current_path).to eq("/admin/merchants")
      merchants[0].reload
      expect(merchants[0].status).to eq("disabled")
      within '.enabled-merchants' do
        expect(page).to_not have_content(merchants[0].name)
      end
      within '.disabled-merchants' do
        expect(page).to have_content(merchants[0].name)
      end
      expect(merchants2[1].status).to eq("disabled")
      within "#disabled-#{merchants2[1].id}" do
        click_button "Enable"
      end

      expect(current_path).to eq("/admin/merchants")
      merchants2[1].reload
      expect(merchants2[1].status).to eq("enabled")
      within '.enabled-merchants' do
        expect(page).to have_content(merchants2[1].name)
      end
      within '.disabled-merchants' do
        expect(page).to_not have_content(merchants2[1].name)
      end
    end

    it 'is grouped into sections by status' do
      merchants = create_list(:merchant, 6, status: 1)
      merchants2 = create_list(:merchant, 2, status: 0)

      visit '/admin/merchants'
      expect(page).to have_content("Enabled Merchants")
      expect(page).to have_content("Disabled Merchants")

      within ".disabled-merchants" do
        expect(page).to have_button('Enable')
        expect(page).to have_content(merchants2[0].name)
        expect(page).to have_content(merchants2[1].name)
        expect(page).to_not have_content(merchants[0].name)
      end

      within ".enabled-merchants" do
        expect(page).to have_button('Disable')
        expect(page).to have_content(merchants[0].name)
        expect(page).to have_content(merchants[1].name)
        expect(page).to_not have_content(merchants2[0].name)
      end
    end
  end

  describe 'admin merchant create' do
    it 'has a link to create a new merchant' do
      visit "/admin/merchants"

      expect(page).to have_content("Create New Merchant")
      click_link "Create New Merchant"
      expect(current_path).to eq(new_merchant_path)
    end
  end

  describe 'top five merchants by revenue' do
    it 'lists the names of the top five merchants and their revenue' do
      merchants = create_list(:merchant, 6, status: 1) 
      merchants2 = create_list(:merchant, 2, status: 0)
      customer = create(:customer) 
    
      item1 = create(:item, merchant: merchants[0], status: 1) 
      item2 = create(:item, merchant: merchants[1], status: 1) 
      item3 = create(:item, merchant: merchants[2], status: 1) 
      item4 = create(:item, merchant: merchants[3], status: 1) 
      item5 = create(:item, merchant: merchants[4], status: 1) 
      item6 = create(:item, merchant: merchants[5], status: 1) 
    
      invoice1 = create(:invoice, customer: customer) 
      invoice2 = create(:invoice, customer: customer) 
      invoice3 = create(:invoice, customer: customer) 
    
      transaction1 = create(:transaction, invoice: invoice1, result: 0) 
      transaction2 = create(:transaction, invoice: invoice1, result: 0) 
      transaction3 = create(:transaction, invoice: invoice2, result: 1) 
      transaction4 = create(:transaction, invoice: invoice2, result: 0) 
      transaction5 = create(:transaction, invoice: invoice3, result: 1) 
      transaction6 = create(:transaction, invoice: invoice3, result: 1) 
    
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 12, unit_price: 100, status: 2) 
      invoice_item2 = create(:invoice_item, item: item1, invoice: invoice3, quantity: 6, unit_price: 4, status: 1) 
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoice1, quantity: 3, unit_price: 200, status: 0) 
      invoice_item4 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 22, unit_price: 200, status: 2) 
      invoice_item5 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 5, unit_price: 300, status: 1) 
      invoice_item6 = create(:invoice_item, item: item3, invoice: invoice1, quantity: 63, unit_price: 400, status: 0) 
      invoice_item7 = create(:invoice_item, item: item4, invoice: invoice2, quantity: 16, unit_price: 500, status: 2) 
      invoice_item8 = create(:invoice_item, item: item4, invoice: invoice3, quantity: 1, unit_price: 500, status: 1) 
      invoice_item9 = create(:invoice_item, item: item5, invoice: invoice2, quantity: 2, unit_price: 500, status: 0) 
      invoice_item10 = create(:invoice_item, item: item5, invoice: invoice1, quantity: 7, unit_price: 200, status: 2) 
      invoice_item11 = create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 100, status: 1) 
      invoice_item12 = create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 250, status: 0) 

      visit '/admin/merchants'

      within "#topMerchant-0" do
        expect(page).to have_link("#{merchants[2].name}")
        expect(page).to have_content("#{merchants[2].name} - $504.00 in sales")
      end

      within "#topMerchant-1" do
        expect(page).to have_link("#{merchants[3].name}")
        expect(page).to have_content("#{merchants[3].name} - $80.00 in sales")
      end

      within "#topMerchant-2" do
        expect(page).to have_link("#{merchants[1].name}")
        expect(page).to have_content("#{merchants[1].name} - $56.00 in sales")
      end

      within "#topMerchant-4" do
        expect(page).to have_link("#{merchants[0].name}")
        expect(page).to have_content("#{merchants[0].name} - $24.00 in sales")
      end

      within "#topMerchant-3" do
        expect(page).to have_link("#{merchants[4].name}")
        expect(page).to have_content("#{merchants[4].name} - $38.00 in sales")
        click_link "#{merchants[4].name}"
      end
      expect(current_path).to eq("/admin/merchants/#{merchants[4].id}")
    end
  end

  describe "Admin Merchants: Top Merchant's Best Day" do
    it "can calculate the date with the most sales" do
      merchants = create_list(:merchant, 6, status: 1) 
      merchants2 = create_list(:merchant, 2, status: 0)
      customer = create(:customer) 
    
      item1 = create(:item, merchant: merchants[0], status: 1) 
      item2 = create(:item, merchant: merchants[1], status: 1) 
      item3 = create(:item, merchant: merchants[2], status: 1) 
      item4 = create(:item, merchant: merchants[3], status: 1) 
      item5 = create(:item, merchant: merchants[4], status: 1) 
      item6 = create(:item, merchant: merchants[5], status: 1) 
    
      invoice1 = create(:invoice, customer: customer, created_at: "2012-03-10 00:54:09 UTC") 
      invoice2 = create(:invoice, customer: customer, created_at: "2013-03-10 00:54:09 UTC") 
      invoice3 = create(:invoice, customer: customer, created_at: "2014-03-10 00:54:09 UTC") 
    
      transaction1 = create(:transaction, invoice: invoice1, result: 0) 
      transaction2 = create(:transaction, invoice: invoice1, result: 0) 
      transaction3 = create(:transaction, invoice: invoice2, result: 1) 
      transaction4 = create(:transaction, invoice: invoice2, result: 0) 
      transaction5 = create(:transaction, invoice: invoice3, result: 1) 
      transaction6 = create(:transaction, invoice: invoice3, result: 1) 
    
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, quantity: 12, unit_price: 100, status: 2) 
      invoice_item2 = create(:invoice_item, item: item1, invoice: invoice3, quantity: 6, unit_price: 4, status: 1) 
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoice1, quantity: 3, unit_price: 200, status: 0) 
      invoice_item4 = create(:invoice_item, item: item2, invoice: invoice2, quantity: 22, unit_price: 200, status: 2) 
      invoice_item5 = create(:invoice_item, item: item3, invoice: invoice3, quantity: 5, unit_price: 300, status: 1) 
      invoice_item6 = create(:invoice_item, item: item3, invoice: invoice1, quantity: 63, unit_price: 400, status: 0) 
      invoice_item7 = create(:invoice_item, item: item4, invoice: invoice2, quantity: 16, unit_price: 500, status: 2) 
      invoice_item8 = create(:invoice_item, item: item4, invoice: invoice3, quantity: 1, unit_price: 500, status: 1) 
      invoice_item9 = create(:invoice_item, item: item5, invoice: invoice2, quantity: 2, unit_price: 500, status: 0) 
      invoice_item10 = create(:invoice_item, item: item5, invoice: invoice1, quantity: 7, unit_price: 200, status: 2) 
      invoice_item11 = create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 100, status: 1) 
      invoice_item12 = create(:invoice_item, item: item6, invoice: invoice3, quantity: 1, unit_price: 250, status: 0)

      visit '/admin/merchants'

      within '#topMerchant-0' do
        expect(page).to have_content("Top selling date for #{merchants[2].name} was #{merchants[2].best_day}")
      end

      within '#topMerchant-1' do
        expect(page).to have_content("Top selling date for #{merchants[3].name} was #{merchants[3].best_day}")
      end

      within '#topMerchant-2' do
        expect(page).to have_content("Top selling date for #{merchants[1].name} was #{merchants[1].best_day}")
      end

      within '#topMerchant-4' do
        expect(page).to have_content("Top selling date for #{merchants[0].name} was #{merchants[0].best_day}")
      end

      within '#topMerchant-3' do
        expect(page).to have_content("Top selling date for #{merchants[4].name} was #{merchants[4].best_day}")
      end
    end
  end

  describe 'Total Revenue and Discounted Revenue' do 
    xit 'displays the total revenue for a merchant from this invoice pre-discounts' do 

    end
  end
end
