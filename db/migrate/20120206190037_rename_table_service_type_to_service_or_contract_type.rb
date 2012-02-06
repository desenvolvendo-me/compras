class RenameTableServiceTypeToServiceOrContractType < ActiveRecord::Migration
  def change
    rename_table :service_types, :service_or_contract_types
  end
end
