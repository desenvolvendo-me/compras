class CreatePledgeRequestItems < ActiveRecord::Migration
  def change
    create_table :compras_pledge_request_items do |t|
      t.integer :pledge_request_id
      t.integer :purchase_process_item_id
      t.integer :accounting_cost_center_id
      t.integer :quantity

      t.timestamps
    end

    add_index :compras_pledge_request_items, :pledge_request_id
    add_index :compras_pledge_request_items, :purchase_process_item_id
    add_index :compras_pledge_request_items, :accounting_cost_center_id

    add_foreign_key :compras_pledge_request_items, :compras_pledge_requests,
      column: :pledge_request_id
    add_foreign_key :compras_pledge_request_items, :compras_purchase_process_items,
      column: :purchase_process_item_id
  end
end
