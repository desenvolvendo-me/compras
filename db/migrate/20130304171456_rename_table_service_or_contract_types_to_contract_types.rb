class RenameTableServiceOrContractTypesToContractTypes < ActiveRecord::Migration
  def change
    rename_table :compras_service_or_contract_types, :compras_contract_types
  end
end