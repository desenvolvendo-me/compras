class AddPurchaseProcessItemIdToLicitationProcessRatificationItems < ActiveRecord::Migration
  def change
    add_column      :compras_licitation_process_ratification_items, :purchase_process_item_id, :integer
    add_index       :compras_licitation_process_ratification_items, :purchase_process_item_id, name: :lprti_purchase_process_item_id
    add_foreign_key :compras_licitation_process_ratification_items, :compras_purchase_process_items, column: :purchase_process_item_id, name: :lprti_purchase_process_item_id_fk

    change_column :compras_licitation_process_ratification_items, :purchase_process_creditor_proposal_id, :integer, null: true
  end
end
