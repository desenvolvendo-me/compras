class AddModalityToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :modality, :string
  end
end
