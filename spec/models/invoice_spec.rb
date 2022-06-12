require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to :customer }
    it { should have_many :transactions }
    it { should have_many :invoice_items }
    it { should have_many(:items).through(:invoice_items) }
    it { should have_many(:merchants).through(:items) }
    it { should have_many(:bulk_discounts).through(:merchants) }
  end

  describe 'validations' do
    it { should define_enum_for(:status).with_values(['in progress', 'completed', 'cancelled']) }
  end

  describe '#instance methods' do
    it '#total_revenue returns total revenue of an invoice' do
      merchant1 = create(:merchant)
      customer1 = create(:customer)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant1)
      invoices = create_list(:invoice, 4, customer: customer1)
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 35)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 14)
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 16) 
      invoice_item4 = create(:invoice_item, item: item3, invoice: invoices[1], unit_price: 5000, quantity: 4)
      invoice_item5 = create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 25)

      expect(invoices[0].total_revenue).to eq(140721)
      expect(invoices[1].total_revenue).to eq(60384)
    end

    it 'formats the date correctly' do
      merchant1 = create(:merchant)
      customer1 = create(:customer)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant1)
      invoices = create_list(:invoice, 4, customer: customer1, created_at: "2022-03-10 00:54:09 UTC")
      transaction1 = create(:transaction, invoice: invoices[0], result: 0)
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 35, status: 2)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 14, status: 1)
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 16, status: 0) 
      invoice_item4 = create(:invoice_item, item: item3, invoice: invoices[1], unit_price: 5000, quantity: 4, status: 1) 
      invoice_item5 = create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 25, status: 2)

      expect(invoices[0].formatted_date).to eq('Thursday, March 10, 2022')
    end

    it 'returns the total merchant revenue' do 
      merchant1 = create(:merchant)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant1)
      invoices = create_list(:invoice, 4)
      transaction1 = create(:transaction, invoice: invoices[1], result: 0)
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 35, status: 2)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 14, status: 1)
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 16, status: 0) 
      invoice_item4 = create(:invoice_item, item: item3, invoice: invoices[1], unit_price: 5000, quantity: 4, status: 1) 
      invoice_item5 = create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 25, status: 2)
      expect(invoices[1].total_merch_rev(merchant1)).to eq(60384)
    end

    it 'can return the total discounted revenue for a merchant' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      expect(invoices[2].merch_discounted_rev(merchant)).to eq(812500.0)
      expect(invoices[1].merch_discounted_rev(merchant)).to eq(52500.0) 
    end

    it 'can return the discounted revenue total for an invoice' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[1], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      expect(invoices[2].discounted_revenue).to eq(812500.0)
      expect(invoices[2].discounted_revenue).to_not eq(1012500.0)
    end
  end

  describe ".class methods" do
    it 'returns all invoices without a shipped status' do
      merchant1 = create(:merchant)
      customer1 = create(:customer)
      item1 = create(:item, merchant: merchant1)
      item2 = create(:item, merchant: merchant1)
      item3 = create(:item, merchant: merchant1)
      invoices = create_list(:invoice, 4, customer: customer1, created_at: "2022-03-10 00:54:09 UTC")
      transaction1 = create(:transaction, invoice: invoices[0], result: 1)
      invoice_item1 = create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 35, status: 2)
      invoice_item2 = create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 14, status: 1)
      invoice_item3 = create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 16, status: 0) 
      invoice_item4 = create(:invoice_item, item: item3, invoice: invoices[1], unit_price: 5000, quantity: 4, status: 1) 
      invoice_item5 = create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 25, status: 2)

      expect(Invoice.not_shipped).to eq([invoices[0], invoices[1], invoices[1]])
      expect(Invoice.not_shipped).to_not eq(invoices[3])
    end
  end
end
