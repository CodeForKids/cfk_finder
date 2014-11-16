require 'test_helper'

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:parent)
  end

  test "should not allow changes to role" do
    error = assert_raises RuntimeError do
      @user.role_type = "Tutor"
      @user.save
    end
    assert_equal "You cannot change your role", error.message
  end
end
