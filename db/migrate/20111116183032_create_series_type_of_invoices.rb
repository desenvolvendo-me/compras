class CreateSeriesTypeOfInvoices < ActiveRecord::Migration
  def change
    create_table :series_type_of_invoices do |t|
      t.string :code
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
