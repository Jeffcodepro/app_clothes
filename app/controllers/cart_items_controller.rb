class CartItemsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]

  before_action :set_cart, only: [:update, :destroy]

  def create
    product_variant = ProductVariant.includes(:product).find_by(id: params[:product_variant_id])

    unless product_variant
      redirect_back fallback_location: products_path, alert: "Escolha um tamanho para adicionar ao carrinho."
      return
    end

    unless product_variant.active? && product_variant.stock_quantity.positive?
      redirect_back fallback_location: product_path(product_variant.product), alert: "Este tamanho está indisponível no momento."
      return
    end

    quantity = normalized_quantity

    unless user_signed_in?
      session[:pending_cart_item] = {
        product_variant_id: product_variant.id,
        quantity: quantity
      }

      redirect_to new_user_session_path, alert: "Entre ou crie sua conta para continuar. Seu item ficará salvo para o carrinho."
      return
    end

    @cart = current_cart
    cart_item = @cart.cart_items.find_or_initialize_by(product_variant: product_variant)
    new_quantity = cart_item.persisted? ? cart_item.quantity + quantity : quantity

    if new_quantity > product_variant.stock_quantity
      redirect_back fallback_location: product_path(product_variant.product),
                    alert: "Temos #{product_variant.stock_quantity} unidade(s) disponível(is) para essa opção."
      return
    end

    cart_item.quantity = new_quantity
    cart_item.unit_price_cents = product_variant.price_cents
    cart_item.save!

    redirect_to cart_path, notice: "#{product_variant.product.name} foi adicionado ao carrinho."
  end

  def update
    cart_item = @cart.cart_items.includes(product_variant: :product).find(params[:id])
    quantity = normalized_quantity

    if quantity <= 0
      cart_item.destroy
      redirect_to cart_path, notice: "Item removido do carrinho."
      return
    end

    product_variant = selected_product_variant_for(cart_item)

    unless product_variant
      redirect_to cart_path, alert: "Essa opção não está disponível."
      return
    end

    unless same_product?(cart_item, product_variant)
      redirect_to cart_path, alert: "Não foi possível alterar este item."
      return
    end

    unless product_variant.active? && product_variant.stock_quantity.positive?
      redirect_to cart_path, alert: "Essa combinação de tamanho e cor está indisponível."
      return
    end

    if quantity > product_variant.stock_quantity
      redirect_to cart_path,
                  alert: "Temos #{product_variant.stock_quantity} unidade(s) disponível(is) para essa opção."
      return
    end

    existing_item = @cart
                    .cart_items
                    .where(product_variant: product_variant)
                    .where.not(id: cart_item.id)
                    .first

    if existing_item
      merged_quantity = existing_item.quantity + quantity

      if merged_quantity > product_variant.stock_quantity
        redirect_to cart_path,
                    alert: "Temos #{product_variant.stock_quantity} unidade(s) disponível(is) para essa opção."
        return
      end

      existing_item.update!(
        quantity: merged_quantity,
        unit_price_cents: product_variant.price_cents
      )

      cart_item.destroy
    else
      cart_item.update!(
        product_variant: product_variant,
        quantity: quantity,
        unit_price_cents: product_variant.price_cents
      )
    end

    redirect_to cart_path
  end

  def destroy
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy

    redirect_to cart_path, notice: "Item removido do carrinho."
  end

  private

  def set_cart
    @cart = current_cart
  end

  def normalized_quantity
    quantity = params[:quantity].to_i
    quantity.positive? ? quantity : 1
  end

  def selected_product_variant_for(cart_item)
    return cart_item.product_variant if params[:product_variant_id].blank?

    ProductVariant.includes(:product).find_by(id: params[:product_variant_id])
  end

  def same_product?(cart_item, product_variant)
    cart_item.product_variant.product_id == product_variant.product_id
  end
end
