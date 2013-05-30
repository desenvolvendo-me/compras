class AddTiedToCreditorProposals < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_creditor_proposals, :tied, :boolean,
      default: false, null: false
  end
end
