class CreateTableComprasDisseminationSourcesComprasRegulatoryActs < ActiveRecord::Migration
  def change
    create_table "compras_dissemination_sources_compras_regulatory_acts", :id => false do |t|
      t.integer "regulatory_act_id"
      t.integer "dissemination_source_id"
    end

    add_index "compras_dissemination_sources_compras_regulatory_acts", ["dissemination_source_id"], :name => "cdscra_dissemination_source_id"
    add_index "compras_dissemination_sources_compras_regulatory_acts", ["regulatory_act_id"], :name => "cdscra_regulatory_act_id"
  end
end
