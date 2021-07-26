class AddImportedToRegulatoryActTypes < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_act_types, :imported, :boolean, :default => false
  end
end
