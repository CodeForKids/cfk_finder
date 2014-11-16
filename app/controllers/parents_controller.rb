class ParentsController < UsersController
private

  def resource_params
    params.require(:parent).permit(:first_name, :last_name, :email,
                                    user_attributes: [:email, :password, :password_confirmation, :current_password],
                                    address_attributes: [:address1, :address2, :city, :province, :postal_code, :country])
  end
end
