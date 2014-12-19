require 'test_helper'

class TutorTest < ActiveSupport::TestCase
  setup do
    @tutor = tutors(:one)
  end

  test "name" do
    assert_equal "john smith", @tutor.name
  end

  test "email" do
    assert_equal "tutor@example.com", @tutor.email
  end

  test "user_attributes" do
    attributes = { user_attributes: { email: "julian2@example.com", password: "12345678" } }
    @tutor.update(attributes)
    assert_equal "julian2@example.com", @tutor.user.email
  end

  test "address_attributes" do
    attributes = { address_attributes: { address1: "126 Fake St" } }
    @tutor.update(attributes)
    assert_equal "126 Fake St", @tutor.address.address1
  end

  test "url" do
    assert_equal @tutor, @tutor.url
  end

  test "has_url?" do
    assert @tutor.has_url?, "Tutor didn't have a url!"
  end
end
