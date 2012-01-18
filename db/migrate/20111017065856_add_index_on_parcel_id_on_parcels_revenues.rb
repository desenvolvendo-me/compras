class AddIndexOnParcelIdOnParcelsRevenues < ActiveRecord::Migration
  def change
    add_index :parcels_revenues, :parcel_id
  end
end
