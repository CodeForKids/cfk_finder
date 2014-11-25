module ActivitiesHelper
  def key_word_for_activity(trackable_type, current_user)
    if ["User"].include?(trackable_type)
      ""
    elsif current_user.role_type == trackable_type
      "their profile"
    else
      indefinite_articlerize(trackable_type)
    end
  end

  def glyphicon_class_for_action(action)
    if action == "updated"
      "glyphicon-repeat"
    elsif action == "created"
      "glyphicon-asterisk"
    elsif action == "deleted"
      "glyphicon-remove"
    elsif action == "changed their password"
      "glyphicon-lock"
    else
      "glyphicon-question-sign"
    end
  end

  def indefinite_articlerize(params_word)
    %w(a e i o u).include?(params_word[0].downcase) ? "an #{params_word}" : "a #{params_word}"
  end
end
