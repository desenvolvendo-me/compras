class AddValueToInvoice < ActiveRecord::Migration
  def change
    add_column :compras_invoices, :value, :decimal,
               :precision => 10, :scale => 2, :default => 0.0
  end
end
