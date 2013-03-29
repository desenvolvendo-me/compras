class AddDefaultValueToNumericFieldsAtPurchaseSolicitationItems < ActiveRecord::Migration
  def change
    change_column :compras_purchase_solicitation_items, :quantity, :decimal, :precision => 10, :scale => 2, :default => 0.0
    change_column :compras_purchase_solicitation_items, :unit_price, :decimal, :precision => 10, :scale => 2, :default => 0.0

    execute <<-SQL
      UPDATE compras_purchase_solicitation_items
      SET quantity = 0.0
      WHERE quantity is NULL
    SQL

    execute <<-SQL
      UPDATE compras_purchase_solicitation_items
      SET unit_price = 0.0
      WHERE unit_price is NULL
    SQL
  end
end
