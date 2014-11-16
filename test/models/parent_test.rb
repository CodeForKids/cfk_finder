require 'test_helper'

class ParentTest < ActiveSupport::TestCase
  test "name" do
    assert_equal "Julian Nadeau", parents(:one).name
  end
end
