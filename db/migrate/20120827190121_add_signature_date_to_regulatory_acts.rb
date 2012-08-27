class AddSignatureDateToRegulatoryActs < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_acts, :signature_date, :date
  end
end
