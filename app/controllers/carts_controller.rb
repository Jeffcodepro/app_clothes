class CartsController < ApplicationController
  def show
    @cart = current_cart
    @cart_items = @cart
                  .cart_items
                  .includes(product_variant: { product: [:category, :product_variants, { photos_attachments: :blob }] })
                  .order(created_at: :desc)
  end
end
