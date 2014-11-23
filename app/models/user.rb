class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  belongs_to :role, :polymorphic => true
  validates :role_type, inclusion: { in: %w( Parent Tutor ) }
  before_validation(on: :update) do
    raise "You cannot change your role" if cannot_change_role?
  end

  before_save :ensure_authentication_token

  def self.roles
    [
      ["Parent", "Parent"],
      ["Tutor", "Tutor"],
      ["Event Organizer", "Tutor"]
    ]
  end

  %w( Parent Tutor ).each do |role|
    define_method("#{role.downcase}?") do
      role_type == role
    end
  end

  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end

 private

  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end

  def cannot_change_role?
    role_id_was && (role_type_changed? || role_id_changed?)
  end
end
