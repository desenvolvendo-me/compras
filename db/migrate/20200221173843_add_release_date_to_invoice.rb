class AddReleaseDateToInvoice < ActiveRecord::Migration
  def change
    add_column :compras_invoices, :release_date, :date
  end
end
