class HomeController < ApplicationController
  skip_before_action :finish_signup
  skip_before_action :authenticate_user!

  def index
    @current_location = current_user ? current_user.role.address : request.location
    @addresses = Address.all.includes(:owner)
    if @current_location
      modifier = @current_location.city.present? ? "to be #{@current_location.city}, please make sure this is correct." : "automatically, please make sure it is correct."
      flash[:notice] = "We detected your location #{modifier}"
    else
      flash[:error] = "We had an issue detecting your location, please find your location on the map."
    end
  end

  def json_markers
    @addresses = Address.all.includes(:owner)
    @hash = @addresses.collect do |address|
      { latitude: address.latitude,
        longitude: address.longitude,
        title: address.owner.name + " (#{address.owner.class.name.humanize})",
        content: address.full_street_address,
        id: address.id }
    end
    render json: @hash
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
