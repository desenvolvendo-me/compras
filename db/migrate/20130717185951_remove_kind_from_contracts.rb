class RemoveKindFromContracts < ActiveRecord::Migration
  def change
    remove_column :compras_contracts, :kind
  end
end
