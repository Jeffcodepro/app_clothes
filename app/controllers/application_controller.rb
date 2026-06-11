class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :set_navbar_collections
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def set_navbar_collections
    @navbar_genders = Gender.active.includes(:categories).order(:position, :name)
    @navbar_categories = Category.active.includes(:gender).order(:position, :name)
    @navbar_sections = Section.active.order(:position, :name)
    @navbar_promotion = NavbarPromotion.current
    @navbar_categories_by_gender = @navbar_categories.group_by(&:gender)
  rescue ActiveRecord::StatementInvalid, ActiveRecord::NoDatabaseError
    @navbar_genders = []
    @navbar_categories = []
    @navbar_sections = []
    @navbar_promotion = nil
    @navbar_categories_by_gender = {}
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
