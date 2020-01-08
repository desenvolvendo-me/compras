class RemoveNumberNfToSupplyOrder < ActiveRecord::Migration

  def change
    remove_column :compras_supply_orders, :number_nf
  end

end
