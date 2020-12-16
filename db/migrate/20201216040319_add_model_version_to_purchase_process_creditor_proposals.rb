class AddModelVersionToPurchaseProcessCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :model_version, :string
  end
end
