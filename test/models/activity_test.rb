require 'test_helper'

class ActivityTest < ActiveSupport::TestCase
  test "register_activity" do
    user = users(:parent)
    kid = user.role.kids.first

    assert_difference("Activity.count") do
      Activity.register_activity(user, kid, "updated", { first_name: "bob" })
    end

    activity = Activity.last
    assert_equal "bob", activity.parameters[:first_name]
    assert_equal user, activity.owner
    assert_equal "updated", activity.action
    assert_equal kid, activity.trackable
  end
end
