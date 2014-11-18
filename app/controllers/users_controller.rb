# This controller is intended to be extended to another controller.
# - This controller should be the base of all "restricted" users.
# - This controller will automatically sandbox users to show, edit, update, and destroy.
# - This controller will allow the user to view new and use create if the user does not have a role_id set
# - This controller will work with any type of user given that the controller is "Role_Type"Controller.
# - The subclass controller needs to override resource_params with its own necessities. This is all it needs to do.

class UsersController < ApplicationController
  before_action :authenticate!
  before_action :set_resource, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_view!, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_creation!, only: [:new, :create]

  skip_before_action :finish_signup, only: [:new, :create]

  def show
  end

  def new
    # For TutorController, this becomes:
    # @tutor = Tutor.new
    # @tutor.address = resource.build_address
    instance_variable_set("@#{controller}", resource_constant.new)
    resource.address = resource.build_address
  end

  def create
    # For TutorController, this becomes:
    # @tutor = Tutor.new(resource_params)
    instance_variable_set("@#{controller}", resource_constant.new(resource_params))

    respond_to do |format|
      if resource.save
        format.html do
          current_user.update_attributes(role_id: resource.id)
          redirect_to resource, notice: "#{controller.humanize} was successfully created."
        end
        format.json { render :show, status: :created, location: resource }
      else
        format.html { render :new }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if resource.update(resource_params)
        format.html { redirect_to resource, notice: "#{controller.humanize} was successfully updated." }
        format.json { render :show, status: :ok, location: resource }
      else
        format.html { render :edit }
        format.json { render json: resource.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    resource.destroy
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

  # Essentially if the user is not a "role", redirect to root
  # Otherwise if the user has a role_id, redirect to their show page
  # if !current_user.tutor?
  #   redirect_to root_url
  # elsif current_user.role_id.present?
  #   redirect_to current_user.role
  # end
  def authenticate_creation!
    if !current_user.send("#{controller}?")
      redirect_to root_url
    elsif current_user.role_id.present?
      redirect_to current_user.role
    end
  end

  # If the controller is TutorsController, this will essentially be
  # current_user.tutor? && @resource == current_user.role
  # This requires the user model to implement the role? method
  # This will essentially check that the user is of type "Role" and is the @resource
  def allowed_view?
    current_user.send("#{controller}?") && @resource == current_user.role
  end

  # If the controller is TutorsController, this will essentially be
  #   @resource = Tutor.find(params[:id])
  #   @tutor = @resource
  def set_resource
    @resource = resource_constant.find(params[:id])
    instance_variable_set("@#{controller}", @resource)
  end

  # If the controller is Tutors controller, this will return @tutor
  def resource
    instance_variable_get("@#{controller}".to_sym)
  end

  # This takes the singularized Model name, humanizes it, then changes it to a constant
  # If the controller is Tutors Controller, this will return Tutor
  def resource_constant
    controller.humanize.constantize
  end

  # For TutorsController (example), this will return tutors
  # We then singularize this to tutor
  def controller
    params[:controller].singularize
  end

  # To be overriden in the subclass
  def resource_params
    {}
  end
end
