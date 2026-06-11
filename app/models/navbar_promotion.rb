class NavbarPromotion < ApplicationRecord
  validates :text, presence: true
  validates :link_url, presence: true
  validates :position, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  scope :active, -> { where(active: true) }

  def self.current
    active.order(:position, created_at: :desc).first
  end
end
