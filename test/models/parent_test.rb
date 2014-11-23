require 'test_helper'

class ParentTest < ActiveSupport::TestCase
  setup do
    @parent = parents(:one)
  end

  test "name" do
    assert_equal "Julian Nadeau", @parent.name
  end

  test "email" do
    assert_equal "julian@example.com", @parent.email
  end

  test "user_attributes" do
    attributes = { user_attributes: { email: "julian2@example.com", password: "12345678" } }
    @parent.update(attributes)
    assert_equal "julian2@example.com", @parent.user.email
  end

  test "address_attributes" do
    attributes = { address_attributes: { address1: "126 Fake St" } }
    @parent.update(attributes)
    assert_equal "126 Fake St", @parent.address.address1
  end
end
