class LikesController < ApplicationController
  before_action :set_product

  def create
    current_user.likes.find_or_create_by!(product: @product)
    @product.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: like_turbo_streams("Produto adicionado aos curtidos.")
      end

      format.html do
        redirect_back fallback_location: product_path(@product), notice: "Produto adicionado aos curtidos."
      end
    end
  end

  def destroy
    current_user.likes.where(product: @product).destroy_all
    @product.reload

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: like_turbo_streams("Produto removido dos curtidos.")
      end

      format.html do
        redirect_back fallback_location: product_path(@product), notice: "Produto removido dos curtidos."
      end
    end
  end

  private

  def set_product
    @product = Product.find_by!(slug: params[:product_id])
  end

  def like_turbo_streams(message)
    [
      turbo_replace_all(
        ".product-like-button-#{@product.id}",
        partial: "products/like_button",
        locals: { product: @product }
      ),
      turbo_replace_all(
        ".product-likes-count-#{@product.id}",
        partial: "products/likes_count",
        locals: { product: @product }
      ),
      turbo_stream.replace(
        "navbar-liked-products-counter",
        partial: "shared/navbar_liked_products_counter"
      ),
      turbo_stream.append(
        "toast-container",
        partial: "shared/toast",
        locals: {
          message: message,
          type: "success"
        }
      )
    ]
  end

  def turbo_replace_all(targets, partial:, locals:)
    view_context.turbo_stream_action_tag(
      :replace,
      targets: targets,
      template: render_to_string(
        partial: partial,
        formats: [:html],
        locals: locals
      )
    )
  end
end
