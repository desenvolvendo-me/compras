class AddCompetenceMonthToInvoice < ActiveRecord::Migration
  def change
    add_column :compras_invoices, :competence_month, :date
  end
end
