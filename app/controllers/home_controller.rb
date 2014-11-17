class HomeController < ApplicationController
  skip_before_action :finish_signup
  skip_before_action :authenticate_user!

  def index
    @current_location = current_user ? current_user.role.address : request.location
  end

  def json_markers
    @addresses = Address.all.includes(:owner)
    @hash = @addresses.collect do |address|
      { latitude: address.latitude,
        longitude: address.longitude,
        title: address.owner.name + " (#{address.owner.class.name.humanize})",
        content: address.full_street_address }
    end
    render json: @hash
  end

end
