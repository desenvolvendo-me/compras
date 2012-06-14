class AddCodeToComprasPurchaseSolicitations < ActiveRecord::Migration
  def change
    add_column :compras_purchase_solicitations, :code, :integer

    add_index :compras_purchase_solicitations, [:accounting_year, :code], :unique => true, :name => :cps_on_accounting_year_and_code_idx
  end
end
