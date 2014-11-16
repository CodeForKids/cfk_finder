class CreateTutors < ActiveRecord::Migration
  def change
    create_table :tutors do |t|
      t.string :first_name
      t.string :last_name
      t.string :date_of_birth
      t.integer :max_students

      t.timestamps
    end
  end
end
