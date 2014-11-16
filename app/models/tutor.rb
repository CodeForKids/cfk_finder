class Tutor < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  has_one :user, :as => :role
  accepts_nested_attributes_for :user

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end

  def user_attributes=(attributes)
    user = self.user
    user.update_with_password(attributes)
  end
end
