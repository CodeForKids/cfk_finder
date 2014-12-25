class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.text :description
      t.integer :spots_available, default: 3
      t.string :event_type
      t.text :materials_needed
      t.references :address, index: true
      t.money :price
      t.decimal :tax_rate, precision: 8, scale: 2
      t.references :subject, index: true
      t.references :owner, polymorphic: true

      t.timestamps
    end
  end
end
