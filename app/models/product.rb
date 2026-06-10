class Product < ApplicationRecord
  MAX_PHOTOS = 5

  belongs_to :category
  belongs_to :section, optional: true

  has_many :product_variants, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many_attached :photos

  validates :name, :slug, :description, :base_price_cents, presence: true
  validates :slug, uniqueness: true
  validates :base_price_cents, numericality: { greater_than_or_equal_to: 0 }

  def to_param
    slug
  end

  def display_price_cents
    product_variants.first&.price_cents || base_price_cents
  end

  def available_sizes
    product_variants.where(active: true).pluck(:size).uniq
  end

  def available_colors
    product_variants.where(active: true).pluck(:color).uniq
  end

  def total_stock
    product_variants.sum(:stock_quantity)
  end

  def in_stock?
    total_stock.positive?
  end

  private

  def photos_limit
    return unless photos.attached?

    if photos.attachments.size > MAX_PHOTOS
      errors.add(:photos, "permite no máximo #{MAX_PHOTOS} imagens")
    end
  end
end
