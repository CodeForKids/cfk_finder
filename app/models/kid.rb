class Kid < BaseModel
  validates :first_name, :last_name, presence: true
  validates :date_of_birth, date: { after: Proc.new { 18.years.ago } }
  belongs_to :parent

  def name
    [first_name, last_name].reject(&:blank?).join(" ")
  end

  def url
    [parent, self]
  end
end
