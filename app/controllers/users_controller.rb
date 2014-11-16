class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_view!, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_creation!, only: [:new, :create]

  skip_before_action :finish_signup, only: [:new, :create]

  def show
  end

  def new
    @resource = resource_constant.new
  end

  def create
    @resource = resource_constant.new(resource_params)

    respond_to do |format|
      if @resource.save
        format.html do
          current_user.update_attributes(role_id: @resource.id)
          redirect_to @parent, notice: '#{controller.humanize} was successfully created.'
        end
        format.json { render :show, status: :created, location: @resource }
      else
        format.html { render :new }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @resource.update(resource_params)
        format.html { redirect_to @resource, notice: "#{controller.humanize} was successfully updated." }
        format.json { render :show, status: :ok, location: @resource }
      else
        format.html { render :edit }
        format.json { render json: @resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @resource.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: "#{controller.humanize} was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  protected

  def authenticate!
    redirect_to current_user.role unless current_user.send("#{controller}?")
  end

  def authenticate_view!
    redirect_to current_user.role unless allowed_view?
  end

  def authenticate_creation!
    if !current_user.send("#{controller}?")
      redirect_to root_url
    elsif !current_user.role_id.nil?
      redirect_to current_user.role
    end
  end

  def allowed_view?
    current_user.send("#{controller}?") && @resource == current_user.role
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
