class AddInvoiceSettlingToInvoice < ActiveRecord::Migration
  def change
    add_column :compras_invoices, :settling_date, :date
    add_column :compras_invoices, :settling_number, :integer
  end
end
