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

  let!(:merchant1) { create(:merchant) }
  let!(:merchant2) { create(:merchant)}
  let!(:customer1) { create(:customer) }

  let!(:item1) { create(:item, merchant: merchant2) }
  let!(:item2) { create(:item, merchant: merchant1) }
  let!(:item3) { create(:item, merchant: merchant1)}

  let!(:invoices) { create_list(:invoice, 4, customer: customer1, created_at: "2022-03-10 00:54:09 UTC") }

  let!(:transaction1) { create(:transaction, invoice: invoices[0], result: 1) }

  let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoices[0], unit_price: 3011, quantity: 35, status: 2) }
  let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoices[0], unit_price: 2524, quantity: 14, status: 1) }
  let!(:invoice_item3) { create(:invoice_item, item: item2, invoice: invoices[1], unit_price: 2524, quantity: 16, status: 0) } #403.84 before
  let!(:invoice_item4) { create(:invoice_item, item: item3, invoice: invoices[1], unit_price: 5000, quantity: 4, status: 1) } #200 before
  let!(:invoice_item5) { create(:invoice_item, item: item2, invoice: invoices[3], unit_price: 2524, quantity: 25, status: 2) }

  describe '#instance methods' do
    it '#total_revenue returns total revenue of an invoice' do
      expect(invoices[0].total_revenue).to eq(140721)
    end

    it 'formats the date correctly' do
      expect(invoices[0].formatted_date).to eq('Thursday, March 10, 2022')
    end

    it 'returns the total merchant revenue' do 
      expect(merchant1.total_rev(merchant1.id)).to eq(603.84)
    end
  end

  describe ".class methods" do
    it 'returns all invoices without a shipped status' do
      expect(Invoice.not_shipped).to eq([invoices[0], invoices[1], invoices[1]])
      expect(Invoice.not_shipped).to_not eq(invoices[3])
    end
  end
end
