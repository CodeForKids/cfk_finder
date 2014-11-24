class Activity < ActiveRecord::Base
  belongs_to :owner, :polymorphic => true
  belongs_to :trackable, :polymorphic => true

  serialize :parameters, Hash

  def self.register_activity(user, trackable, action, params={})
    act = Activity.new
    act.trackable = trackable
    act.owner = user
    act.action = action
    act.parameters = params
    act.ip_address = user.try(:current_sign_in_ip)
    act.save
    true
  end
end
