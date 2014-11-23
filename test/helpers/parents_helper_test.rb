require 'test_helper'

class ParentsHelperTest < ActionView::TestCase
  setup do
    @parent = parents(:one)
  end

  test "delete_phrase" do
     assert_equal "Are you sure you want to delete the parent profile for Julian Nadeau?", delete_phrase(@parent)
  end
end
