class AddPrincipalContractToContracts < ActiveRecord::Migration
  def change
    add_column :compras_contracts, :principal_contract, :boolean
  end
end
