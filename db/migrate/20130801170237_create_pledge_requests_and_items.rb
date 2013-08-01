class CreatePledgeRequestsAndItems < ActiveRecord::Migration
  def change
    create_table :compras_pledge_request_items, force: true do |t|
      t.integer :pledge_request_id
      t.integer :purchase_process_item_id
      t.integer :accounting_cost_center_id
      t.integer :quantity

      t.timestamps
    end

    create_table :compras_pledge_requests, force: true do |t|
      t.integer :descriptor_id
      t.integer :budget_allocation_id
      t.integer :expense_nature_id
      t.integer :accounting_account_id
      t.integer :contract_id
      t.integer :reserve_fund_id
      t.integer :purchase_process_id
      t.integer :creditor_id
      t.decimal :amount, precision: 10, scale: 2
      t.text    :historic_complement
      t.date    :emission_date

      t.timestamps
    end

    add_index :compras_pledge_requests, :descriptor_id
    add_index :compras_pledge_requests, :budget_allocation_id
    add_index :compras_pledge_requests, :expense_nature_id
    add_index :compras_pledge_requests, :accounting_account_id
    add_index :compras_pledge_requests, :reserve_fund_id
    add_index :compras_pledge_requests, :contract_id
    add_index :compras_pledge_requests, :purchase_process_id

    add_foreign_key :compras_pledge_requests, :compras_licitation_processes, column: :purchase_process_id
    add_foreign_key :compras_pledge_requests, :compras_contracts, column: :contract_id
    add_foreign_key :compras_pledge_requests, :unico_creditors, column: :creditor_id

    add_index :compras_pledge_request_items, :pledge_request_id
    add_index :compras_pledge_request_items, :purchase_process_item_id
    add_index :compras_pledge_request_items, :accounting_cost_center_id

    add_foreign_key :compras_pledge_request_items, :compras_pledge_requests,
      column: :pledge_request_id
    add_foreign_key :compras_pledge_request_items, :compras_purchase_process_items,
      column: :purchase_process_item_id
  end
end

