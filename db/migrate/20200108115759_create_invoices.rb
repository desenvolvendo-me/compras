class CreateInvoices < ActiveRecord::Migration
  def change
    create_table "compras_invoices" do |t|
      t.string :number
      t.references :supply_order

      t.timestamps
    end
    add_index :compras_invoices, :supply_order_id
  end
end
