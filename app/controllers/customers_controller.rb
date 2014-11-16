class ParentsController < UsersController
  before_action :set_parent, only: [:show, :edit, :update, :destroy]

  private

  def set_parent
    @parent = @resource
  end

  def resource_params
    params.require(:parent).permit(:first_name, :last_name, :email, user_attributes: [:email, :password, :password_confirmation, :current_password])
  end

end
