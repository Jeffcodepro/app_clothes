class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  def index
    @categories = Category.where(active: true).order(:position)
    @products = Product
                .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                .where(active: true)
                .order(created_at: :desc)

    if params[:category].present?
      @category = Category.find_by(slug: params[:category])
      @products = @products.where(category: @category) if @category
    end
  end

  def show
    @product = Product.find_by!(slug: params[:id])
    @variants = @product.product_variants.where(active: true)
    @related_products = Product
                        .where(category: @product.category, active: true)
                        .where.not(id: @product.id)
                        .limit(4)
  end
end
