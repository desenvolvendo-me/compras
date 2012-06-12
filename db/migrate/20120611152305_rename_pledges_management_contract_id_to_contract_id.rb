class RenamePledgesManagementContractIdToContractId < ActiveRecord::Migration
  def change
    rename_column :pledges, :management_contract_id, :contract_id
  end
end
