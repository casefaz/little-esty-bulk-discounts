require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do 
  describe 'relationships' do
    it { should belong_to :merchant }
    it { should have_many(:items).through(:merchant) }
    it { should have_many(:invoice_items).through(:items) }
    it { should have_many(:invoices).through(:invoice_items) }
    it { should have_many(:customers).through(:invoices) }
    it { should have_many(:transactions).through(:customers) }
  end

  describe 'validations' do 
    it { should validate_numericality_of :quantity_threshold }
    it { should validate_numericality_of :percentage }
  end
end