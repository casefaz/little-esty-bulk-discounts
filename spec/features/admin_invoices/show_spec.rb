require 'rails_helper'

RSpec.describe 'Admin Invoice Show Page', type: :feature do
  it 'lists invoice attributes' do
    customer1 = create(:customer)
    invoice1 = create(:invoice, customer: customer1, status: 0)

    visit "/admin/invoices/#{invoice1.id}"
    expect(page).to have_content("Invoice ##{invoice1.id}")
    expect(page).to have_content("Created on: #{invoice1.created_at.strftime('%A, %B %d, %Y')}")
    expect(page).to have_content("#{invoice1.customer.first_name} #{invoice1.customer.last_name}")
  end

  it 'lists items on the invoice' do
    merchant1 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    customer1 = create(:customer)
    invoice1 = create(:invoice, customer: customer1, status: 0)
    transaction1 = create(:transaction, invoice: invoice1, result: 1)
    invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011, quantity: 5)
    invoice_item2 = create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524, quantity: 3)

    visit "/admin/invoices/#{invoice1.id}"
    within '#itemtable' do
      expect(page).to have_content('Item Name')
      expect(page).to have_content('Unit Price')
      expect(page).to have_content('Status')
      expect(page).to have_content('Quantity')
    end

    within "#invoice-item-#{invoice_item1.id}" do
      expect(page).to have_text(item1.name.to_s)
      expect(page).to have_text('$30.11')
      expect(page).to have_text(invoice_item1.quantity.to_s)
      expect(page).to have_text(invoice_item1.status.to_s)
    end
  end

  it 'shows total revenue that will be generated from this invoice' do
    merchant1 = create(:merchant)
    item1 = create(:item, merchant: merchant1)
    item2 = create(:item, merchant: merchant1)
    customer1 = create(:customer)
    invoice1 = create(:invoice, customer: customer1, status: 0)
    transaction1 = create(:transaction, invoice: invoice1, result: 1)
    invoice_item1 = create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011, quantity: 5)
    invoice_item2 = create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524, quantity: 3)

    visit "/admin/invoices/#{invoice1.id}"

    expect(page).to have_content('Total Revenue: $226.27')
  end

  it 'has a select field to update invoice status' do
    customer1 = create(:customer)
    invoice1 = create(:invoice, customer: customer1, status: 0)

    visit "/admin/invoices/#{invoice1.id}"
    expect(invoice1.status).to eq('in progress')

    have_select :status,
                selected: 'in progress',
                options: ['in progress', 'completed', 'cancelled']

    select 'completed', from: :status
    click_button 'Update Invoice Status'

    expect(current_path).to eq("/admin/invoices/#{invoice1.id}")
    invoice1.reload
    expect(invoice1.status).to eq('completed')

    have_select :status,
                selected: 'completed',
                options: ['in progress', 'completed', 'cancelled']
  end

  describe 'Admin Invoice Total and Discounted Revenue' do 
    it 'shows the total revenue from this invoice' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      visit invoice_path(invoices[1].id)
      within "#leftSide2" do 
        expect(page).to have_content('Total Revenue: $750.00')
        expect(page).to have_content('Total Discounted Revenue: $525.00')
      end
    end
  end
end
