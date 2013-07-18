class RemoveRelationshipBetweenCreditorAndBidder < ActiveRecord::Migration
  def change
    remove_column :compras_bidders, :creditor_id
  end
end
