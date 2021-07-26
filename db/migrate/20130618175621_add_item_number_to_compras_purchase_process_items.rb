class AddItemNumberToComprasPurchaseProcessItems < ActiveRecord::Migration
  def change
    add_column :compras_purchase_process_items, :item_number, :integer
  end
end
