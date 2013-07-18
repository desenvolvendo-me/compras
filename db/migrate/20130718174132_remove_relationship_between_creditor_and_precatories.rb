class RemoveRelationshipBetweenCreditorAndPrecatories < ActiveRecord::Migration
  def change
    remove_column :compras_precatories, :creditor_id
  end
end
