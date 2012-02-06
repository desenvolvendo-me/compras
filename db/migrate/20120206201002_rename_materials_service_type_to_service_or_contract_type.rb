class RenameMaterialsServiceTypeToServiceOrContractType < ActiveRecord::Migration
  def change
    remove_index :materials, :service_type_id
    remove_foreign_key :materials, :service_types

    rename_column :materials, :service_type_id, :service_or_contract_type_id

    add_index :materials, :service_or_contract_type_id
    add_foreign_key :materials, :service_or_contract_types
  end
end
