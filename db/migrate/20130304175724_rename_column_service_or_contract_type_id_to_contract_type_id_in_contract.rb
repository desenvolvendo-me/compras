class RenameColumnServiceOrContractTypeIdToContractTypeIdInContract < ActiveRecord::Migration
  def change
    rename_column :compras_contracts, :service_or_contract_type_id, :contract_type_id
  end
end