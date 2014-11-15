class Customer < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true
  has_many :kids, foreign_key: :parent_id

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
end
