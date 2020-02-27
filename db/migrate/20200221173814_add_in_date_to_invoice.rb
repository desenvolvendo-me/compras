class AddInDateToInvoice < ActiveRecord::Migration
  def change
    add_column :compras_invoices, :date, :date
  end
end
