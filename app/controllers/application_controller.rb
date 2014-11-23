class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  before_filter :authenticate_user_from_token!
  before_action :authenticate_user!

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :finish_signup, if: :user_not_finished_signup?

  protected

  # Handles Format for Auth Methods
  def redirect_auth(url)
    respond_to do |format|
      format.html { redirect_to url }
      format.json do
        head :unauthorized
      end
    end
  end

  def authenticate_user_from_token!
    user_email = request.headers["X-Entity-Email"].presence
    user       = user_email && User.find_by_email(user_email)

    if user && Devise.secure_compare(user.authentication_token, request.headers["X-Entity-Token"])
      sign_in user, store: false
    end
  end

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
