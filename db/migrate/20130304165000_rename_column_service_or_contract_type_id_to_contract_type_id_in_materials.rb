class RenameColumnServiceOrContractTypeIdToContractTypeIdInMaterials < ActiveRecord::Migration
  def change
    rename_column :compras_materials, :service_or_contract_type_id, :contract_type_id
  end
end