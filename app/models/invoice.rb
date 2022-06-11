class Invoice < ApplicationRecord
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  belongs_to :customer

  enum status:["in progress", "completed", "cancelled"]

  def total_revenue
    invoice_items.sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def total_merch_rev(merchant)
    items.where(merchant_id: merchant)
    .sum('invoice_items.unit_price * invoice_items.quantity')
  end

  def merch_discounted_rev(merchant)
    # binding.pry
    invoice_items.sum { |invoice_item| invoice_item.discounted_rev }
  end

  def discounted_revenue
    binding.pry
  end

  def self.not_shipped
    all
    .joins(:invoice_items)
    .where.not("invoice_items.status = ?", 2)
    .order(created_at: :desc)
  end

  def formatted_date
    created_at.strftime("%A, %B %d, %Y")
  end
end
