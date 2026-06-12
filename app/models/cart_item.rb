class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product_variant

  has_one :product, through: :product_variant

  validates :quantity, numericality: { greater_than: 0 }
  validates :unit_price_cents, numericality: { greater_than_or_equal_to: 0 }

  def total_cents
    quantity * unit_price_cents
  end
end
