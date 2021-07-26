class RemoveRelationshipBetweenAgreementsAndRegulatoryActs < ActiveRecord::Migration
  def change
    if connection.table_exists? :compras_expense_natures
      remove_column :compras_agreements, :regulatory_act_id
    end
  end

  protected

  def connection
    ActiveRecord::Base.connection
  end
end
