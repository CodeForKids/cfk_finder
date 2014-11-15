require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test "name" do
    assert_equal "Julian Nadeau", customers(:one).name
  end
end
