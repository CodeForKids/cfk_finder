class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :first_name
      t.string :last_name
      t.string :gender
      t.datetime :date_of_birth
      t.integer :parent_id
      t.timestamps
    end
  end
end
