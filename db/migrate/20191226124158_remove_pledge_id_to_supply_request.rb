class RemovePledgeIdToSupplyRequest < ActiveRecord::Migration
  def change
    remove_column :compras_supply_requests, :pledge_id
  end
end
