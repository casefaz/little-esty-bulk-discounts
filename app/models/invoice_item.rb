class InvoiceItem < ApplicationRecord
  belongs_to :invoice
  belongs_to :item
  has_many :merchants, through: :item
  has_many :bulk_discounts, through: :merchants
  has_many :transactions, through: :invoice

  validates_numericality_of :quantity
  validates_numericality_of :unit_price
  enum status:["pending", "packaged", "shipped"]

  def greatest_discount
    bulk_discounts.where('bulk_discounts.quantity_threshold <= ?', quantity).order(percentage: :desc).first
  end
end
