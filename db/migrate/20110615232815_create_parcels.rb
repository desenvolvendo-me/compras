class CreateParcels < ActiveRecord::Migration
  def change
    create_table :parcels do |t|
      t.string :name
      t.references :splitting
      t.string :parcel_number
      t.date :due_date
      t.boolean :single_parcel, :default => true

      t.timestamps
    end
    add_index :parcels, :splitting_id
    add_foreign_key :parcels, :splittings
  end
end
