class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @categories = Category.where(active: true).order(:position)
    @featured_products = Product
                        .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                        .where(active: true, featured: true)
                        .limit(4)

    @new_products = Product
                    .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                    .where(active: true)
                    .order(created_at: :desc)
                    .limit(8)
  end
end
