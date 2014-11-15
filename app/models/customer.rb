class Customer < ActiveRecord::Base
  validates :first_name, :last_name, :email, presence: true

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
end
