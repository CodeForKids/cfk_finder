class TutorsController < UsersController
private

  def resource_params
    params.require(:tutor).permit(:first_name, :last_name, :date_of_birth, :max_students,
                                  user_attributes: [:email, :password, :password_confirmation, :current_password],
                                  address_attributes: [:address1, :address2, :city, :province, :postal_code, :country])
  end
end
