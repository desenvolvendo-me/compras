class RemoveRelationshipBetweenCreditorAndCreditorMaterial < ActiveRecord::Migration
  def change
    remove_column :compras_creditor_materials, :creditor_id
  end
end
