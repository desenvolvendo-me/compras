class AddCalculatedTaxToPropertyTransfers < ActiveRecord::Migration
  def change
    add_column :property_transfers, :calculated_tax, :decimal, :precision => 10, :scale => 2
  end
end
