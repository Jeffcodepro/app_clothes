class LikesController < ApplicationController
  before_action :set_product

  def create
    current_user.likes.find_or_create_by!(product: @product)

    redirect_back fallback_location: product_path(@product), notice: "Produto adicionado aos curtidos."
  end

  def destroy
    current_user.likes.where(product: @product).destroy_all

    redirect_back fallback_location: product_path(@product), notice: "Produto removido dos curtidos."
  end

  private

  def set_product
    @product = Product.find_by!(slug: params[:product_id])
  end
end
