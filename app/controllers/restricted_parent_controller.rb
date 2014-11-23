class RestrictedParentController < ApplicationController
  before_action :authenticate!
  before_action :set_parent
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_view!

  protected

  def authenticate!
    redirect_auth current_user.role unless current_user.parent?
  end

  def authenticate_view!
    redirect_auth current_user.role unless allowed_view?
  end

  def allowed_view?
    current_user.parent? && current_user.role == @parent
  end

  def set_parent
    @parent = Parent.find(params[:parent_id])
  end

  def set_resource
    @resource = resource_constant.find(params[:id])
  end

  # Example:
  # If we are subclassing this in KidsController,
  # controller will be "kid", so this will
  # capitalize and constantize it to "Kid"
  def resource_constant
    controller.humanize.constantize
  end

  # Example:
  # If we are calling this from the subclasses "KidsController"
  # we will get "Kids", and this will return "Kid"
  def controller
    params[:controller].singularize
  end

  # To be overriden in subclasses
  def resource_params
    {}
  end
end
