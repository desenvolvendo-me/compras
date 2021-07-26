class AddColumnToPurchaseProcessItems < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_items, :estimated_value, :decimal, precision: 10,  scale: 2
    add_column :compras_purchase_process_items, :max_value, :decimal, precision: 10,  scale: 2
    add_column :compras_purchase_process_items, :benefit_type, :string
  end
end
