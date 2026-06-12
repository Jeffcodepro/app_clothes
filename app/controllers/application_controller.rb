class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_navbar_collections
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_cart

  private

  def current_cart
    return unless user_signed_in?

    current_user.cart || current_user.create_cart!(status: "active")
  end

  def set_navbar_collections
    @navbar_genders = Gender.active.includes(:categories).order(:position, :name)
    @navbar_categories = Category.active.includes(:gender).order(:position, :name)
    @navbar_sections = Section.active.order(:position, :name)
    @navbar_promotion = NavbarPromotion.current
    @navbar_categories_by_gender = @navbar_categories.group_by(&:gender)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError, NameError
    @navbar_genders = []
    @navbar_categories = []
    @navbar_sections = []
    @navbar_promotion = nil
    @navbar_categories_by_gender = {}
  end

  def after_sign_in_path_for(resource)
    if add_pending_cart_item_to_cart(resource)
      cart_path
    else
      super
    end
  end

  def after_sign_up_path_for(resource)
    if add_pending_cart_item_to_cart(resource)
      cart_path
    else
      super
    end
  end

  def add_pending_cart_item_to_cart(user)
    pending_item = session.delete(:pending_cart_item)
    return false unless pending_item.present?

    product_variant = ProductVariant.find_by(id: pending_item["product_variant_id"])
    quantity = pending_item["quantity"].to_i
    quantity = 1 if quantity < 1

    unless product_variant&.active? && product_variant.stock_quantity.positive?
      flash[:alert] = "O item escolhido não está mais disponível."
      return false
    end

    cart = user.cart || user.create_cart!(status: "active")
    cart_item = cart.cart_items.find_or_initialize_by(product_variant: product_variant)

    new_quantity = cart_item.persisted? ? cart_item.quantity + quantity : quantity

    if new_quantity > product_variant.stock_quantity
      flash[:alert] = "Quantidade maior que o estoque disponível."
      return true
    end

    cart_item.quantity = new_quantity
    cart_item.unit_price_cents = product_variant.price_cents
    cart_item.save!

    flash[:notice] = "#{product_variant.product.name} foi adicionado ao carrinho."
    true
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: [:first_name, :last_name, :phone]
    )

    devise_parameter_sanitizer.permit(
      :account_update,
      keys: [:first_name, :last_name, :phone]
    )
  end
end
