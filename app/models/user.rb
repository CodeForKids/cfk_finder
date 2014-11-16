class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :trackable, :validatable

  belongs_to :role, :polymorphic => true
  validates :role_type, inclusion: { in: %w( Parent Tutor ) }
  before_validation(on: :update) do
    raise "You cannot change your role" if cannot_change_role?
  end

  def self.roles
    [
      ["Parent", "Parent"],
      ["Tutor", "Tutor"],
      ["Event Organizer", "Tutor"]
    ]
  end

  def parent?
    role_type == "Parent"
  end

  def tutor?
    role_type == "Tutor"
  end

  private

  def cannot_change_role?
    role_id_was && (role_type_changed? || role_id_changed?)
  end
end
