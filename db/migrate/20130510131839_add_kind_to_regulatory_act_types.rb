class AddKindToRegulatoryActTypes < ActiveRecord::Migration
  def change
    add_column :compras_regulatory_act_types, :kind, :integer, null: true
  end
end
