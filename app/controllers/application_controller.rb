class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :finish_signup, if: :user_not_finished_signup?

  def index
    @addresses = Address.all.includes(:owner)
    @hash = @addresses.collect do |address|
      { latitude: address.latitude,
        longitude: address.longitude,
        title: address.owner.name + " (#{address.owner.class.name.humanize})",
        content: address.full_street_address }
    end
  end

  protected

  def user_not_finished_signup?
    current_user && current_user.role_id.nil?
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:role_id, :role_type, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :role_id, :role_type, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:role_id, :role_type, :email, :password, :password_confirmation, :current_password) }
  end

  def finish_signup
    flash[:notice] = "Please finish your registration before continuing"
    if current_user.parent?
      redirect_to new_parent_path and return
    elsif current_user.tutor?
      redirect_to new_tutor_path and return
    else
      redirect_to root_url and return
    end
  end

end
