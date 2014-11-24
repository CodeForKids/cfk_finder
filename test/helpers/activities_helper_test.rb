require 'test_helper'

class ActivitiesHelperTest < ActionView::TestCase
  setup do
    @user = users(:parent)
  end

  test "key_word_for_activity" do
    assert_equal "their profile", key_word_for_activity(@user.role_type, @user)
    assert_equal "a Kid", key_word_for_activity("Kid", @user)
    assert_equal "an Apple", key_word_for_activity("Apple", @user)
  end

  test "glyphicon_class_for_action" do
    assert_equal "glyphicon-repeat", glyphicon_class_for_action("updated")
    assert_equal "glyphicon-asterisk", glyphicon_class_for_action("created")
    assert_equal "glyphicon-remove", glyphicon_class_for_action("destroyed")
    assert_equal "glyphicon-lock", glyphicon_class_for_action("changed their password")
    assert_equal "glyphicon-question-sign", glyphicon_class_for_action("unknown")
  end
end
