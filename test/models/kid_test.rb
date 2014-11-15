require 'test_helper'

class KidTest < ActiveSupport::TestCase
  test "name" do
    assert_equal "Bob Smith", kids(:one).name
  end
end
