class ChangeDateFormatTables < ActiveRecord::Migration
  def up
    change_column :kids, :date_of_birth, :date
    change_column :tutors, :date_of_birth, :date
  end

  def down
    change_column :kids, :date_of_birth, :datetime
    change_column :tutors, :date_of_birth, :datetime
  end
end
