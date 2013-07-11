class RemoveDisseminationSourcesComprasRegulatoryActs < ActiveRecord::Migration
  def change
    drop_table :compras_dissemination_sources_compras_regulatory_acts
  end
end
