class Tutor < BaseUser
  has_many :events, as: :owner, dependent: :destroy
end
