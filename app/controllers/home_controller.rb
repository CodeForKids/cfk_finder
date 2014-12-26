class HomeController < ApplicationController
  skip_before_action :finish_signup
  skip_before_action :authenticate_user!

  def index
    @current_location = current_user ? current_user.role.address : request.location
    @events = Event.all.includes(:address)
    if @current_location
      modifier = @current_location.city.present? ? "to be #{@current_location.city}, please make sure this is correct." : "automatically, please make sure it is correct."
      flash[:notice] = "We detected your location #{modifier}"
    else
      flash[:error] = "We had an issue detecting your location, please find your location on the map."
    end
  end

  def authenticate
    email = request.headers["X-Entity-Email"].presence
    password = request.headers["X-Entity-Password"].presence
    if email && password
      json_password_auth(email, password)
    else
      head 400
    end
  end

  protected

  def json_password_auth(email, password)
    user = User.find_by(email: email)
    if user && user.valid_password?(password)
      render json: user.token_hash, status: :ok
    else
      head :unauthorized
    end
  end

end
