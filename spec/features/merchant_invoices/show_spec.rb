require 'rails_helper'

RSpec.describe 'Merchant_Invoices Show Page', type: :feature do
  describe 'Merchant_Invoices User Story 2' do
    it "can display all information related to an invoice" do
      merchant = create(:merchant)
      customer = create(:customer)
      customer2 = create(:customer)
      invoice = create(:invoice, customer: customer2)
      invoices = create_list(:invoice, 2, customer: customer)
      visit "/merchants/#{merchant.id}/invoices/#{invoices[0].id}"

      expect(page).to have_content("Invoice: #{invoices[0].id}")
      expect(page).to have_content("Status: #{invoices[0].status}")
      expect(page).to have_content("Created on: #{invoices[0].created_at.strftime("%A, %B %d, %Y")}")
      expect(page).to_not have_content("Invoice: #{invoice.id}")
      expect(page).to_not have_content("Invoice: #{invoices[1].id}")
      
      expect(page).to have_content("#{customer.first_name} #{customer.last_name}")
      expect(page).to_not have_content("#{customer2.first_name} #{customer2.last_name}")
    end
  end

  describe 'Merchant_Invoices User Story 3' do
    it 'can display items attributes that belongs to an invoice' do
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      customer = create(:customer)
      items = create_list(:item, 2, merchant: merchant)
      items2 = create_list(:item, 2, merchant: merchant2)
      invoices = create_list(:invoice, 2, customer: customer)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[0])
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[1])

      visit "/merchants/#{merchant.id}/invoices/#{invoices[0].id}"

      within '#itemtable' do
        expect(page).to have_content("Item Name")
        expect(page).to have_content("Quantity")
        expect(page).to have_content("Unit Price")
        expect(page).to have_content("Status")
        expect(page).to have_content(items[0].name)
        expect(page).to_not have_content(items2[1].name)
        expect(page).to have_content(invoice_item1.quantity)
        expect(page).to have_content(invoice_item1.unit_price / 100.0)
        expect(page).to_not have_content(invoice_item2.unit_price / 100.0)
        expect(page).to have_content(invoice_item1.status)
      end
    end
  end

  describe "User Story 4 - Merchant Invoice Show Page: Total Revenue" do
    it "shows the total revenue of all items on an invoice" do
      merchants = create_list(:merchant, 2)
      customers = create_list(:customer, 6)
  
      item1 = create(:item, merchant: merchants[0])
      item2 = create(:item, merchant: merchants[1])
  
      invoice1 = create(:invoice, customer: customers[0])
      invoice2 = create(:invoice, customer: customers[1])
      invoice3 = create(:invoice, customer: customers[2])
      invoice4 = create(:invoice, customer: customers[3])
      invoice5 = create(:invoice, customer: customers[4])
      invoice6 = create(:invoice, customer: customers[5])
  
      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice1, result: 1)
      transaction3 = create(:transaction, invoice: invoice2, result: 0)
      transaction4 = create(:transaction, invoice: invoice2, result: 1)
      transaction5 = create(:transaction, invoice: invoice3, result: 0)
      transaction6 = create(:transaction, invoice: invoice3, result: 0)
      transaction7 = create(:transaction, invoice: invoice4, result: 0)
      transaction8 = create(:transaction, invoice: invoice4, result: 1)
      transaction9 = create(:transaction, invoice: invoice5, result: 0)
      transaction10 = create(:transaction, invoice: invoice5, result: 1)
      transaction11 = create(:transaction, invoice: invoice6, result: 0)
      transaction12 = create(:transaction, invoice: invoice6, result: 1)
  
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, status: 0)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, status: 1)
      invoice_item3 = create(:invoice_item, item: item1, invoice: invoice3, status: 1)
      invoice_item4 = create(:invoice_item, item: item2, invoice: invoice4, status: 0)
      invoice_item5 = create(:invoice_item, item: item1, invoice: invoice5, status: 0)
      invoice_item6 = create(:invoice_item, item: item2, invoice: invoice6, status: 1)

      visit "/merchants/#{merchants[0].id}/invoices/#{invoice1.id}"

      expect(page).to have_content("Total Revenue for Invoice: $#{(invoice1.total_revenue.to_f / 100.0).round(2)}")
    end
  end

  describe "User Story 5 - Merchant Invoice Show Page: Update Item Status" do
    it "has a select field button for invoice item's status and has a button to update the status" do
      merchants = create_list(:merchant, 2)
      customers = create_list(:customer, 6)
  
      item1 = create(:item, merchant: merchants[0])
      item2 = create(:item, merchant: merchants[1])
  
      invoice1 = create(:invoice, customer: customers[0])
      invoice2 = create(:invoice, customer: customers[1])
      invoice3 = create(:invoice, customer: customers[2])
      invoice4 = create(:invoice, customer: customers[3])
      invoice5 = create(:invoice, customer: customers[4])
      invoice6 = create(:invoice, customer: customers[5])
  
      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice1, result: 1)
      transaction3 = create(:transaction, invoice: invoice2, result: 0)
      transaction4 = create(:transaction, invoice: invoice2, result: 1)
      transaction5 = create(:transaction, invoice: invoice3, result: 0)
      transaction6 = create(:transaction, invoice: invoice3, result: 0)
      transaction7 = create(:transaction, invoice: invoice4, result: 0)
      transaction8 = create(:transaction, invoice: invoice4, result: 1)
      transaction9 = create(:transaction, invoice: invoice5, result: 0)
      transaction10 = create(:transaction, invoice: invoice5, result: 1)
      transaction11 = create(:transaction, invoice: invoice6, result: 0)
      transaction12 = create(:transaction, invoice: invoice6, result: 1)
  
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, status: 0)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoice2, status: 1)
      invoice_item3 = create(:invoice_item, item: item1, invoice: invoice3, status: 1)
      invoice_item4 = create(:invoice_item, item: item2, invoice: invoice4, status: 0)
      invoice_item5 = create(:invoice_item, item: item1, invoice: invoice5, status: 0)
      invoice_item6 = create(:invoice_item, item: item2, invoice: invoice6, status: 1)

      visit "/merchants/#{merchants[0].id}/invoices/#{invoice1.id}"
      
      expect(invoice_item1.status).to eq("pending")

      within "#invoiceItem-#{invoice_item1.id}" do
        have_select :status,
        selected: "pending",
        options: ["pending", "packaged", "shipped"]

        select "packaged", from: :status
        click_button "Update Item Status"
      end

      expect(current_path).to eq("/merchants/#{merchants[0].id}/invoices/#{invoice1.id}")
      invoice_item1.reload
      expect(invoice_item1.status).to eq("packaged")

      within "#invoiceItem-#{invoice_item1.id}" do
        have_select :status,
        selected: "packaged",
        options: ["pending", "packaged", "shipped"]
      end
    end
  end

  describe 'Merchant Invoice: Total Revenue and Discounted Revenue' do 
    it 'displays the total revenue for a particular merchant pre discount' do 
      merchant = create(:merchant)
      merchant2 = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      item3 = create(:item, merchant: merchant2)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      invoice_item4 = create(:invoice_item, item: item3, invoice: invoices[2], unit_price: 40000, quantity: 30)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      visit merchant_invoice_path(merchant.id, invoices[2].id)
      expect(page).to have_content("Total Revenue for #{merchant.name} Before Discount: $10,125.00") 
      expect(page).to have_content("Total Revenue for #{merchant.name} After Discount: $8,125.00")
      expect(page).to_not have_content("Total Revenue for #{merchant.name}: $25.00")
      expect(page).to_not have_content("#{merchant2.name}")
      expect(page).to_not have_content(item3.name)
    end
  end

  describe 'Link to applied discounts' do 
    it 'has a link next to each invoice item for the bulk discount that was applied' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      visit merchant_invoice_path(merchant.id, invoices[2].id)

      expect(page).to have_content('Bulk Discount')
      within "#invoiceItem-#{invoice_item1.id}" do 
        expect(page).to have_link('Discount Applied')
        click_link 'Discount Applied'
      end
      expect(current_path).to eq(merchant_bulk_discount_path(merchant.id, bulk1.id))
      expect(page).to have_content(bulk1.percentage)
      expect(page).to have_content(bulk1.quantity_threshold)
      expect(page).to_not have_content(bulk2.percentage)

      visit merchant_invoice_path(merchant.id, invoices[1].id)
      within "#invoiceItem-#{invoice_item3.id}" do 
        expect(page).to have_link('Discount Applied')
        click_link 'Discount Applied'
      end
      expect(current_path).to eq(merchant_bulk_discount_path(merchant.id, bulk2.id))
      expect(page).to have_content(bulk2.percentage)
      expect(page).to have_content(bulk2.quantity_threshold)
      expect(page).to_not have_content(bulk1.percentage)
    end

    it 'has no link if no discount was applied' do
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      visit merchant_invoice_path(merchant.id, invoices[2].id)

      within "#invoiceItem-#{invoice_item2.id}" do 
        expect(page).to have_content('no discount applied')
      end
    end
  end
end
