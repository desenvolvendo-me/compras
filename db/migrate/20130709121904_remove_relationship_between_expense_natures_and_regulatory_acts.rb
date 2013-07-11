class RemoveRelationshipBetweenExpenseNaturesAndRegulatoryActs < ActiveRecord::Migration
  def change
    remove_column :compras_expense_natures, :regulatory_act_id
  end
end
