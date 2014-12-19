class Activity < ActiveRecord::Base
  default_scope { order(created_at: :desc) }
  belongs_to :owner, :polymorphic => true
  belongs_to :trackable, :polymorphic => true

  serialize :parameters, Hash

  def self.register_activity(user, trackable, action, ip_address, params={})
    act = Activity.new
    act.trackable = trackable
    act.owner = user
    act.action = action
    act.parameters = params
    act.ip_address = ip_address
    act.save
    true
  end
end
