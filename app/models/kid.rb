class Kid < ActiveRecord::Base
  validates :first_name, :last_name, presence: true
  validates :date_of_birth, date: { after: Proc.new { 18.years.ago } }
  belongs_to :parent, class_name: "Customer", foreign_key: :parent_id

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end
end