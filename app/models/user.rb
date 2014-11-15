class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  belongs_to :role, :polymorphic => true

  def self.roles
    [
      ["Parent", "Customer"],
      ["Tutor", "Tutor"],
      ["Event Organizer", "Tutor"]
    ]
  end

  def customer?
    role_type == "Customer"
  end

  def tutor?
    role_type == "Tutor"
  end
end
