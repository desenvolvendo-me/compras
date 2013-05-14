class AddRankingToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :ranking, :integer
  end
end
