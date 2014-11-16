class KidsController < RestrictedParentController
  before_action :set_kid, only: [:show, :edit, :update, :destroy]

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
        format.html { redirect_to [@parent, @kid], notice: 'Kid was successfully created.' }
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
        format.html { redirect_to [@parent, @kid], notice: 'Kid was successfully updated.' }
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
      format.html { redirect_to parent_path(@parent), notice: 'Kid was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_kid
    @kid = @resource
  end

  def set_parent
    @parent = Parent.find(params[:parent_id])
  end

  def kid_params
    params.require(:kid).permit(:first_name, :last_name, :gender, :date_of_birth, :parent_id)
  end
end
