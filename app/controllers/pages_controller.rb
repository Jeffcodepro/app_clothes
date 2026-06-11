class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @featured_products = Product
                         .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                         .where(active: true, featured: true)
                         .limit(8)

    @new_products = Product
                    .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                    .where(active: true)
                    .order(created_at: :desc)
                    .limit(12)
  end
end
