class DropRegulatoryActTypes < ActiveRecord::Migration
  def change
    drop_table :compras_regulatory_act_types
  end
end
