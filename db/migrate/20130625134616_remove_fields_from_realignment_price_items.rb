class RemoveFieldsFromRealignmentPriceItems < ActiveRecord::Migration
  def up
    remove_column :compras_realignment_price_items, :purchase_process_creditor_proposal_id
  end

  def down
    add_column :compras_realignment_price_items, :purchase_process_creditor_proposal_id, :integer
  end
end
