class Parent < ActiveRecord::Base
  validates :first_name, :last_name, presence: true

  has_many :kids, foreign_key: :parent_id

  has_one :address, as: :owner
  accepts_nested_attributes_for :address

  has_one :user, :as => :role
  accepts_nested_attributes_for :user

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end

  def user_attributes=(attributes)
    user = self.user
    user.update_with_password(attributes)
  end

  def address_attributes=(attributes)
    address = self.address || self.build_address
    address.update(attributes)
  end
end
