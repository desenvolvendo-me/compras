class RemoveRelationshipBetweenExpenseNaturesAndRegulatoryActs < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_expense_natures
      remove_column :compras_expense_natures, :regulatory_act_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
