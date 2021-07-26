class RemoveEntityFromComprasContracts < ActiveRecord::Migration
  def change
    remove_column :compras_contracts, :entity_id
  end
end
