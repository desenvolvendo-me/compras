class CreateSubRevenueParcels < ActiveRecord::Migration
  def change
    create_table :sub_revenue_parcels do |t|
      t.integer :principal_revenue_id
      t.string :year
      t.references :parcel
      t.integer :secondary_revenue_id
      t.decimal :discount_percentage, :precision => 10, :scale => 2

      t.timestamps
    end
    add_index :sub_revenue_parcels, :parcel_id
    add_index :sub_revenue_parcels, :principal_revenue_id
    add_index :sub_revenue_parcels, :secondary_revenue_id
    add_foreign_key :sub_revenue_parcels, :parcels
    add_foreign_key :sub_revenue_parcels, :revenues, :column => :principal_revenue_id
    add_foreign_key :sub_revenue_parcels, :revenues, :column => :secondary_revenue_id
  end
end
