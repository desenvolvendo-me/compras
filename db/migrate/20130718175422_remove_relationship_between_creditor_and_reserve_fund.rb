class RemoveRelationshipBetweenCreditorAndReserveFund < ActiveRecord::Migration
  def change
    remove_column :compras_reserve_funds, :creditor_id
  end
end
