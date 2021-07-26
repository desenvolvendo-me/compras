class AddPurchaseProcessTradingsTable < ActiveRecord::Migration
  def change
    create_table :compras_purchase_process_tradings do |t|
      t.integer :purchase_process_id, null: false
    end

    add_index :compras_purchase_process_tradings, :purchase_process_id, name: :cppt_purchase_process_idx

    add_foreign_key :compras_purchase_process_tradings, :compras_licitation_processes, column: :purchase_process_id, name: :cppt_purchase_process_fk
  end
end
