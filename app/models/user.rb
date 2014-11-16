class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role, :polymorphic => true

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
end
