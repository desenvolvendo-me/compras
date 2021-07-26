class AddClassificationToRegulatoryActs < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_acts, :classification, :string
  end
end
