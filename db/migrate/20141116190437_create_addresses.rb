class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :address1
      t.string :address2
      t.string :city
      t.string :province
      t.string :country
      t.string :postal_code
      t.float :latitude
      t.float :longitude
      t.references :owner, polymorphic: true

      t.timestamps
    end

    User.all.each do |u|
      u.role.create_address({})
    end
  end
end
