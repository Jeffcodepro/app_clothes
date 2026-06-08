class ProductVariant < ApplicationRecord
  belongs_to :product

  validates :size, :color, :sku, :stock_quantity, :price_cents, presence: true
  validates :sku, uniqueness: true
  validates :stock_quantity, numericality: { greater_than_or_equal_to: 0 }
  validates :price_cents, numericality: { greater_than_or_equal_to: 0 }
end
