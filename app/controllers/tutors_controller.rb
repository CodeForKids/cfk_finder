class TutorsController < UsersController
  before_action :set_tutor, only: [:show, :edit, :update, :destroy]

  private

  def set_tutor
    @tutor = @resource
  end

  def resource_params
    params.require(:tutor).permit(:first_name, :last_name, :date_of_birth, :max_students, user_attributes: [:email, :password, :password_confirmation, :current_password])
  end
end
