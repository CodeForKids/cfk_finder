class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]
  skip_before_action :finish_signup, only: [:new, :create]
  before_action :authenticate!, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_creation!, only: [:new, :create]

  def show
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.new(customer_params)
    @customer.email = current_user.email

    respond_to do |format|
      if @customer.save
        format.html do
          current_user.update_attributes(role_id: @customer.id)
          redirect_to @customer, notice: 'Customer was successfully created.'
        end
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to @customer, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate!
    redirect_to customer_path(current_user.role) unless allowed_view_customer?
  end

  def authenticate_creation!
    if current_user.role_type != "Customer"
      redirect_to root_url
    elsif !current_user.role_id.nil?
      redirect_to customer_path(current_user.role)
    end
  end

  def allowed_view_customer?
    @customer == current_user.role
  end

  def set_customer
    @customer = Customer.find(params[:id])
  end

  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, user_attributes: [:email, :password, :password_confirmation, :current_password])
  end

end
