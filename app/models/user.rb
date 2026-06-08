class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { customer: 0, admin: 1 }

  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product

  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_one :cart, dependent: :destroy

  validates :role, presence: true
end
