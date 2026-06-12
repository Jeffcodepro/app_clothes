class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items, dependent: :destroy
  has_many :product_variants, through: :cart_items

  enum :status, {
    active: "active",
    ordered: "ordered",
    abandoned: "abandoned"
  }

  validates :status, presence: true

  def total_cents
    cart_items.to_a.sum(&:total_cents)
  end

  def items_count
    cart_items.sum(:quantity)
  end

  def empty?
    cart_items.empty?
  end
end
