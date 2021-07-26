class RemoveModalityFromContracts < ActiveRecord::Migration
  def change
    remove_column :compras_contracts, :modality
  end
end
