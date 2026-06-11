class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @genders = Gender.active.order(:position, :name)
    @sections = Section.active.order(:position, :name)

    @products = Product
                .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                .joins(category: :gender)
                .where(active: true)
                .order(created_at: :desc)

    filter_by_gender
    filter_by_category
    filter_by_section
    filter_by_query

    @categories = available_categories
  end

  def show
    @product = Product.find_by!(slug: params[:id])
    @variants = @product.product_variants.where(active: true)

    @related_products = Product
                        .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                        .where(category: @product.category, active: true)
                        .where.not(id: @product.id)
                        .limit(4)
  end

  private

  def filter_by_gender
    return if params[:gender].blank?

    @gender = Gender.find_by(slug: params[:gender])
    @products = @products.where(categories: { gender_id: @gender.id }) if @gender
  end

  def filter_by_category
    return if params[:category].blank?

    @category = Category.find_by(slug: params[:category])

    return unless @category

    @gender ||= @category.gender
    @products = @products.where(category: @category)
  end

  def filter_by_section
    return if params[:section].blank?

    @section = Section.find_by(slug: params[:section])
    @products = @products.where(section: @section) if @section
  end

  def filter_by_query
    return if params[:query].blank?

    query = "%#{params[:query].strip}%"

    @products = @products.where(
      "products.name ILIKE :query OR products.description ILIKE :query",
      query: query
    )
  end

  def available_categories
    scope = Category.active.includes(:gender).order(:position, :name)

    if @gender
      scope.where(gender: @gender)
    else
      scope
    end
  end
end
