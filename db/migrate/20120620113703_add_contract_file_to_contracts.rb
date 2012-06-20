class AddContractFileToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :contract_file, :string
  end
end
