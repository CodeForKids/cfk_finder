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

  test "has role method that work" do
    assert @user.parent?, "User was not a parent"
    assert_not @user.tutor?, "User was a tutor"
  end

  test "roles" do
    assert_equal ["Parent", "Tutor"], User.roles
  end

  test "token_hash" do
    hash = { authentication_token: "12345", email: "julian@example.com", id: 1032740943 }
    assert_equal hash, @user.token_hash
  end
end
