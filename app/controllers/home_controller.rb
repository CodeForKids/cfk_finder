class HomeController < ApplicationController
  skip_before_action :finish_signup, only: :index
  skip_before_action :authenticate_user!, only: :index

  def index
    @current_location = current_user ? current_user.role.address : request.location
    @addresses = Address.all.includes(:owner)
    @hash = @addresses.collect do |address|
      { latitude: address.latitude,
        longitude: address.longitude,
        title: address.owner.name + " (#{address.owner.class.name.humanize})",
        content: address.full_street_address }
    end
  end

end
