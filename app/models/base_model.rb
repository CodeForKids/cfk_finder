class BaseModel < ActiveRecord::Base
  self.abstract_class = true
  has_one :activity, as: :trackable

  before_validation(on: :update) do
    if self.changes.present?
      Activity.register_activity(User.current_user, self, "updated", action_params)
    end
    true
  end

  after_create do
    Activity.register_activity(User.current_user, self, "created")
    true
  end

  after_destroy do
    Activity.register_activity(User.current_user, self, "destroyed")
    true
  end

  private

  def action_params
    changes = {}
    self.changes.each do |key, change|
      changes[key] = "changed the value for #{key} from \"#{change.first}\" to \"#{change.last}\"" if valid_key?(key)
    end
    changes
  end

  def valid_key?(key)
    !["encrypted_password", "created_at", "updated_at"].include?(key)
  end
end
