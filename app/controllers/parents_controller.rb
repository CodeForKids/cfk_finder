class ParentsController < UsersController
private

  def resource_params
    params.require(:parent).permit(:first_name, :last_name, :email, user_attributes: [:email, :password, :password_confirmation, :current_password])
  end
end
