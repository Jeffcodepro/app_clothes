class LikedProductsController < ApplicationController
  def show
    @products = Product
                .includes(:category, :section, :product_variants, :likes, :favorites, photos_attachments: :blob)
                .joins(:likes)
                .where(likes: { user_id: current_user.id })
                .order("likes.created_at DESC")
  end
end
