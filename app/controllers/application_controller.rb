class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include CartHelper

  before_action :config_permitted_parameters, if: :devise_controller?
  before_action :set_locale

  private
  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    {locale: I18n.locale}
  end

  def config_permitted_parameters
    register_attrs = [:name, :phone, :email, :password, :password_confirmation]
    update_attrs = [:name, :phone, :email, :password, :password_confirmation,
                    :picture]
    devise_parameter_sanitizer.permit :sign_up, keys: register_attrs
    devise_parameter_sanitizer.permit :account_update, keys: update_attrs
  end

  rescue_from CanCan::AccessDenied do |_exception|
    if user_signed_in?
      flash[:danger] = t "controllers.application.not_permition"
      redirect_to root_path
    else
      flash[:danger] = t "controllers.application.login_please"
      redirect_to new_user_session_path
    end
  end

  def current_ability
    controller_name_segments = params[:controller].split("/")
    controller_name_segments.pop
    controller_namespace = controller_name_segments.join("").camelize
    @current_ability ||= Ability.new(current_user, controller_namespace)
  end
end
