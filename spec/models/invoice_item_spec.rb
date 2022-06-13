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

  describe 'instance methods' do 
    it 'finds discounts that are applicable' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 2500, quantity: 5)
      invoice_item3 = create(:invoice_item, item: items[1], invoice: invoices[1], unit_price: 3000, quantity: 25)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 25, percentage: 30.0, merchant: merchant)

      expect(invoice_item1.greatest_discount).to eq(bulk1)
      expect(invoice_item1.greatest_discount).to_not eq(bulk2)
      expect(invoice_item3.greatest_discount).to eq(bulk2)
      expect(invoice_item2.greatest_discount).to eq(nil)
    end

    it 'returns the total revenue with discount if applicable and doesnt subtract the discount if not applicable' do 
      merchant = create(:merchant)
      items = create_list(:item, 2, merchant: merchant)
      invoices = create_list(:invoice, 3)
      invoice_item1 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 50000, quantity: 20)
      invoice_item2 = create(:invoice_item, item: items[0], invoice: invoices[2], unit_price: 2500, quantity: 5)
      bulk1 = create(:bulk_discount, merchant: merchant)
      bulk2 = create(:bulk_discount, quantity_threshold: 15, percentage: 15, merchant: merchant)

      expect(invoice_item1.discounted_rev).to eq(800000.0)
      expect(invoice_item2.discounted_rev).to eq(12500.0) #not impacted by discount - doesn't meet threshold
    end
  end
end
