class RenameManagementContractsToContracts < ActiveRecord::Migration
  def change
    rename_table :management_contracts, :contracts
  end
end
