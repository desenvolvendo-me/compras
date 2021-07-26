class DropTablePledgeParcels < ActiveRecord::Migration
  def change
    drop_table :compras_pledge_parcels
  end
end
