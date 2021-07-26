class RemoveRelationshipBetweenCreditorAndRealignmentPrice < ActiveRecord::Migration
  def change
    remove_column :compras_realignment_prices, :creditor_id
  end
end
