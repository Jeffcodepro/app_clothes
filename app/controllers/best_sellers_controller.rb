class BestSellersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]
  before_action :set_gender, only: [:index]

  def index
    weekly_product_ids = weekly_best_seller_product_ids

    @products =
      if weekly_product_ids.any?
        products_by_id = Product
                         .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                         .where(active: true, id: weekly_product_ids)
                         .index_by(&:id)

        weekly_product_ids.map { |product_id| products_by_id[product_id] }.compact
      else
        fallback_products
      end
  end

  private

  def set_gender
    return if params[:gender].blank?

    @gender = Gender.find_by(slug: params[:gender])

    return if @gender.present?

    redirect_to weekly_best_sellers_path, alert: "Gênero não encontrado."
  end

  def weekly_best_seller_product_ids
    scope = OrderItem
            .joins(product_variant: { product: { category: :gender } })
            .where(created_at: Time.current.beginning_of_week..Time.current.end_of_week)

    scope = scope.where(genders: { id: @gender.id }) if @gender.present?

    scope
      .group("products.id")
      .order(Arel.sql("SUM(order_items.quantity) DESC"))
      .pluck("products.id")
  end

  def fallback_products
    scope = Product
            .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
            .joins(category: :gender)
            .where(active: true, featured: true)
            .order(created_at: :desc)
            .limit(12)

    scope = scope.where(genders: { id: @gender.id }) if @gender.present?

    scope
  end
end
