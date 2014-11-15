class KidsController < ApplicationController
  before_action :set_kid, only: [:show, :edit, :update, :destroy]
  before_action :authenticate!, only: [:show, :edit, :update, :destroy]

  def show
  end

  def new
    @kid = Kid.new
  end

  def create
    @kid = Kid.new(kid_params)
    @kid.parent = current_user.role

    respond_to do |format|
      if @kid.save
        format.html { redirect_to @kid, notice: 'Kid was successfully created.' }
        format.json { render :show, status: :created, location: @kid }
      else
        format.html { render :new }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @kid.update(kid_params)
        format.html { redirect_to @kid, notice: 'Kid was successfully updated.' }
        format.json { render :show, status: :ok, location: @kid }
      else
        format.html { render :edit }
        format.json { render json: @kid.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @kid.destroy
    respond_to do |format|
      format.html { redirect_to kids_url, notice: 'Kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def authenticate!
    redirect_to root_url unless allowed_access?
  end

  def allowed_access?
    current_user.role == @kid.parent
  end

  def set_kid
    @kid = Kid.find(params[:id])
  end

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :gender, :date_of_birth, :parent_id)
  end
end
