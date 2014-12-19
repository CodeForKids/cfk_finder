require 'test_helper'

class KidTest < ActiveSupport::TestCase
  setup do
    @kid = kids(:one)
  end

  test "name" do
    assert_equal "Bob Smith", @kid.name
  end

  test "url" do
    assert_equal [@kid.parent, @kid], @kid.url
  end

  test "has_url?" do
    assert @kid.has_url?, "Kid didn't have a url!"
  end
end
