class AddInvoiceDateToSupplyOrder < ActiveRecord::Migration
  def change
    add_column :compras_supply_orders, :invoice_date, :date
  end
end
