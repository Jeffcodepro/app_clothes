class Section < ApplicationRecord
  has_many :products, dependent: :nullify

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true
end
