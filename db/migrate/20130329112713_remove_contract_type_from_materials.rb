class RemoveContractTypeFromMaterials < ActiveRecord::Migration
  def change
    remove_column :compras_materials, :contract_type_id
  end
end
