class RenameTableParcelsRevenues < ActiveRecord::Migration
  def change
    rename_table :parcels_revenues, :parcel_revenues
  end
end
