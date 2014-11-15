class Kid < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  belongs_to :parent, class_name: "Customer", foreign_key: :parent_id

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
end
