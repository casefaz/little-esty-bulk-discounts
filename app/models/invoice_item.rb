class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  has_many :transactions, through: :invoice

  validates_numericality_of :quantity
  validates_numericality_of :unit_price
  enum status:["pending", "packaged", "shipped"]

  def unit_price_converted
    helpers.number_to_currency(self.unit_price.to_f/100)
  end

private
  # Helper Methods
  def helpers
  ActionController::Base.helpers
  end
end
