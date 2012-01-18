class DropSubRevenueParcels < ActiveRecord::Migration
  def change
    drop_table :sub_revenue_parcels
  end
end
