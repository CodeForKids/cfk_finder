class RestrictedParentController < ApplicationController
  before_action :authenticate!
  before_action :set_parent
  before_action :set_resource, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_view!

  protected

  def authenticate!
    redirect_to current_user.role unless current_user.parent?
  end

  def authenticate_view!
    redirect_to current_user.role unless allowed_view?
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

  def resource_constant
    controller.humanize.constantize
  end

  def controller
    params[:controller].singularize
  end

  def resource_params
    {}
  end
end
