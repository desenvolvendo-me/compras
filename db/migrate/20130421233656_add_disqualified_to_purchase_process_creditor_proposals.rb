class AddDisqualifiedToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :disqualified, :boolean, default: false, null: false
  end
end
