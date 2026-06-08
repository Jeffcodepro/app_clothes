class Product < ApplicationRecord
  belongs_to :category
  belongs_to :section, optional: true

  has_many :product_variants, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :photos

  validates :name, :slug, :description, :base_price_cents, presence: true
  validates :slug, uniqueness: true
  validates :base_price_cents, numericality: { greater_than_or_equal_to: 0 }
end
