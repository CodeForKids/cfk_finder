class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.references :trackable, polymorphic: true, index: true
      t.references :owner, polymorphic: true, index: true
      t.string :action
      t.string :ip_address
      t.text :parameters
      t.timestamps
    end
  end
end
