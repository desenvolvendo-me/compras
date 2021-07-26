class RemoveRelationshipBetweenCreditorAndSupplyOrder < ActiveRecord::Migration
  def change
    remove_column :compras_supply_orders, :creditor_id
  end
end
