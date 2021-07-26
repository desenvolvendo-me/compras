class AddDeliveryTermToPurchaseProcessCreditorProposal < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :delivery_term, :date
  end
end
