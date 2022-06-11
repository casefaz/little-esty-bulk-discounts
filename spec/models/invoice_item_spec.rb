require 'rails_helper'

RSpec.describe InvoiceItem, type: :model do
  describe "relationships" do
    it { should belong_to :invoice }
    it { should belong_to :item }
    it { should have_many(:merchants).through(:item) }
    it { should have_many(:bulk_discounts).through(:merchants) }
    it { should have_many(:transactions).through(:invoice) }

  end

  describe 'validations' do
    it { should validate_numericality_of :quantity}
    it { should validate_numericality_of :unit_price}
    it { should define_enum_for(:status).with_values(["pending", "packaged", "shipped"])}
  end

  # let!(:merchant1) { create(:merchant) }

  # let!(:item1) { create(:item, merchant: merchant1) }
  # let!(:item2) { create(:item, merchant: merchant1) }

  # let!(:customer1) { create(:customer) }

  # let!(:invoice1) { create(:invoice, customer: customer1) }

  # let!(:transaction1) { create(:transaction, invoice: invoice1, result: 1) }

  # let!(:invoice_item1) { create(:invoice_item, item: item1, invoice: invoice1, unit_price: 3011) }
  # let!(:invoice_item2) { create(:invoice_item, item: item2, invoice: invoice1, unit_price: 2524) }

  describe 'instance methods' do 
    it 'finds discounts that are applicable' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 2500, quantity: 5)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 15, percentage: 15, merchant: merchant)

      expect(invoice_item1.greatest_discount).to eq(bulk1)
      expect(invoice_item2.greatest_discount).to eq(nil)
    end
  end
end
