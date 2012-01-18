class RemoveParcelNumberFromParcels < ActiveRecord::Migration
  def change
    remove_column :parcels, :parcel_number
  end
end
