require 'rails_helper'

RSpec.describe 'Merchant_Invoices Show Page', type: :feature do
  # let!(:merchants) { create_list(:merchant, 2) }
  # let!(:customers) { create_list(:customer, 6) }

  # before :each do
  #   @items = merchants.flat_map do |merchant|
  #     create_list(:item, 2, merchant: merchant)
  #   end

  #   @invoices = customers.flat_map do |customer|
  #     create_list(:invoice, 2, customer: customer)
  #   end

  #   @transactions = @invoices.each_with_index.flat_map do |invoice, index|
  #     if index < 2
  #       create_list(:transaction, 2, invoice: invoice, result: 1)
  #     else
  #       create_list(:transaction, 2, invoice: invoice, result: 0)
  #     end
  #   end

  # end
  # let!(:invoice_item1) { create(:invoice_item, item: @items[0], invoice: @invoices[0], status: 0) }
  # let!(:invoice_item2) { create(:invoice_item, item: @items[1], invoice: @invoices[1], status: 1) }
  # let!(:invoice_item3) { create(:invoice_item, item: @items[0], invoice: @invoices[2], status: 1) }
  # let!(:invoice_item4) { create(:invoice_item, item: @items[1], invoice: @invoices[3], status: 0) }
  # let!(:invoice_item5) { create(:invoice_item, item: @items[0], invoice: @invoices[4], status: 0) }
  # let!(:invoice_item6) { create(:invoice_item, item: @items[1], invoice: @invoices[5], status: 1) }
  # let!(:invoice_item7) { create(:invoice_item, item: @items[0], invoice: @invoices[6], status: 1) }
  # let!(:invoice_item8) { create(:invoice_item, item: @items[1], invoice: @invoices[7], status: 1) }
  # let!(:invoice_item9) { create(:invoice_item, item: @items[0], invoice: @invoices[8], status: 1) }
  # let!(:invoice_item10) { create(:invoice_item, item: @items[1], invoice: @invoices[9], status: 0) }
  # let!(:invoice_item11) { create(:invoice_item, item: @items[0], invoice: @invoices[10], status: 2) }
  # let!(:invoice_item12) { create(:invoice_item, item: @items[2], invoice: @invoices[11], status: 1) }
  # let!(:invoice_item13) { create(:invoice_item, item: @items[2], invoice: @invoices[0], status: 1) }

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

      expect(page).to have_content("Total Revenue: #{invoice1.total_revenue}")
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
    it 'displays the total revenue for a merchant pre discount' do 
      #any revenue from invoices with any items belonging to that merchant - if items.merchant_id: merchant_id - calculate the total revenue
      merchant = create(:merchant)
      customer = create(:customer)
      items = create_list(:item, 4, merchant: merchant)
  
      invoice1 = create(:invoice, customer: customer)
      invoice2 = create(:invoice, customer: customer)
      invoice3 = create(:invoice, customer: customer)

      transaction1 = create(:transaction, invoice: invoice1, result: 1)
      transaction2 = create(:transaction, invoice: invoice2, result: 0)
      transaction3 = create(:transaction, invoice: invoice2, result: 0)
      transaction4 = create(:transaction, invoice: invoice2, result: 1)
      transaction5 = create(:transaction, invoice: invoice2, result: 0)
      transaction6 = create(:transaction, invoice: invoice3, result: 0)

      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoice1, quantity: 5, unit_price: 1000)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoice2, quantity: 10, unit_price: 3000) #300
      invoice_item3 = create(:invoice_item, item: items[2], invoice: invoice2, quantity: 5, unit_price: 2000) #100
      invoice_item4 = create(:invoice_item, item: items[3], invoice: invoice2, quantity: 22, unit_price: 5000) #1,100
      invoice_item5 = create(:invoice_item, item: items[0], invoice: invoice2, quantity: 15, unit_price: 1500)
      invoice_item6 = create(:invoice_item, item: items[1], invoice: invoice3, quantity: 100, unit_price: 2500)

      visit merchant_invoice_path(merchant.id, invoice2.id)
      expect(page).to have_content("Total Revenue for #{merchant.name}: $1,500.00") 
      expect(page).to_not have_content("Total Revenue for #{merchant.name}: $25.00")
    end
  end
end
