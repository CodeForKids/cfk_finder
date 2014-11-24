class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable

  has_many :activities, as: :owner
  belongs_to :role, :polymorphic => true
  validates :role_type, inclusion: { in: %w( Parent Tutor ) }
  before_validation(on: :update) do
    raise "You cannot change your role" if cannot_change_role?
    Activity.register_activity(User.current_user, self, "changed their password", User.current_ip_address) if self.encrypted_password_changed?
    true
  end

  before_save :ensure_authentication_token

  delegate :name, to: :role

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

  def token_hash
    { authentication_token: authentication_token, email: email, id: id }
  end

  class << self
    def current_user=(user)
      Thread.current[:current_user] = user
    end

    def current_user
      Thread.current[:current_user]
    end

    def current_ip_address=(ip)
      Thread.current[:current_ip_address] = ip
    end

    def current_ip_address
      Thread.current[:current_ip_address]
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
