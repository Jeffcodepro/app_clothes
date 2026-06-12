class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :omniauthable,
         omniauth_providers: [:google_oauth2, :apple]

  enum :role, { customer: 0, admin: 1 }

  has_many :likes, dependent: :destroy
  has_many :liked_products, through: :likes, source: :product

  has_many :favorites, dependent: :destroy
  has_many :favorite_products, through: :favorites, source: :product

  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :nullify
  has_one :cart, dependent: :destroy

  validates :role, presence: true

  def self.from_omniauth(auth)
    provider = auth.provider
    uid = auth.uid
    email = auth.info.email.presence
    first_name = extract_first_name(auth)
    last_name = extract_last_name(auth)
    avatar_url = auth.info.image.presence

    user = find_by(provider: provider, uid: uid)

    if user
      attributes = {}

      attributes[:email] = email if email.present?
      attributes[:first_name] = first_name if first_name.present?
      attributes[:last_name] = last_name if last_name.present?
      attributes[:avatar_url] = avatar_url if avatar_url.present?

      user.update!(attributes) if attributes.any?

      return user
    end

    user = find_by(email: email) if email.present?

    if user
      attributes = {
        provider: provider,
        uid: uid
      }

      attributes[:first_name] = first_name if user.first_name.blank? && first_name.present?
      attributes[:last_name] = last_name if user.last_name.blank? && last_name.present?
      attributes[:avatar_url] = avatar_url if user.avatar_url.blank? && avatar_url.present?

      user.update!(attributes)

      return user
    end

    raise ActiveRecord::RecordInvalid, new if email.blank?

    create!(
      email: email,
      password: Devise.friendly_token[0, 20],
      first_name: first_name.presence || "Cliente",
      last_name: last_name.presence || "",
      avatar_url: avatar_url,
      provider: provider,
      uid: uid,
      role: :customer
    )
  end

  def self.extract_first_name(auth)
    return auth.info.first_name if auth.info.respond_to?(:first_name) && auth.info.first_name.present?

    name = auth.info.name.to_s.strip
    return if name.blank?

    name.split.first
  end

  def self.extract_last_name(auth)
    return auth.info.last_name if auth.info.respond_to?(:last_name) && auth.info.last_name.present?

    name = auth.info.name.to_s.strip
    return if name.blank?

    parts = name.split
    return "" if parts.size <= 1

    parts[1..].join(" ")
  end
end
